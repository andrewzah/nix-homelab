{config, ...}: {
  sops.secrets."traefik/env" = {};

  virtualisation.oci-containers.containers.traefik = {
    autoStart = true;
    image = "docker.io/library/traefik:v3.6.5@sha256:67622638cd88dbfcfba40159bc652ecf0aea0e032f8a3c7e3134ae7c037b9910";
    cmd = [
      "--api.insecure=true"
      "--api.dashboard=true"
      "--log.level=INFO" # ERROR default

      "--providers.docker=true"
      "--providers.docker.exposedbydefault=false"

      "--entrypoints.web.address=:80"
      "--entrypoints.websecure.address=:443"
      "--entrypoints.ssh.address=:2223"

      "--entrypoints.web.forwardedHeaders.insecure"
      "--entrypoints.websecure.forwardedHeaders.insecure"

      ## entrypoint redirections
      "--entrypoints.web.http.redirections.entryPoint.to=websecure"
      "--entrypoints.web.http.redirections.entryPoint.scheme=https"
      "--entrypoints.web.http.redirections.entrypoint.permanent=true"

      ## generic resolver
      "--certificatesresolvers.generic.acme.tlschallenge=true"
      "--certificatesresolvers.generic.acme.email=admin@andrewzah.com"
      "--certificatesresolvers.generic.acme.storage=/letsencrypt/acme.json"
      #"--certificatesResolvers.generic.acme.caServer=https://acme-staging-v02.api.letsencrypt.org/directory"

      ## porkbun resolver
      "--certificatesresolvers.porkbun.acme.storage=/letsencrypt/porkbun-acme.json"
      "--certificatesresolvers.porkbun.acme.email=admin@andrewzah.com"
      "--certificatesresolvers.porkbun.acme.dnschallenge=true"
      "--certificatesresolvers.porkbun.acme.dnsChallenge.provider=porkbun"
      "--certificatesresolvers.porkbun.acme.dnsChallenge.resolvers=1.1.1.1:53,1.0.0.1:53"

      ## cloudflare resolver
      "--certificatesresolvers.cloudflare.acme.storage=/letsencrypt/cloudflare-acme.json"
      "--certificatesresolvers.cloudflare.acme.email=admin@andrewzah.com"
      "--certificatesresolvers.cloudflare.acme.dnschallenge=true"
      "--certificatesresolvers.cloudflare.acme.dnsChallenge.provider=cloudflare"
      "--certificatesresolvers.cloudflare.acme.dnsChallenge.delayBeforeCheck=0"
      "--certificatesresolvers.cloudflare.acme.dnsChallenge.resolvers=1.1.1.1:53"
    ];

    ports = [
      "80:80" # http
      "443:443" # https
      "2223:2223" # ssh alternate port
      "8080:8080" # dashboard
    ];
    environmentFiles = [config.sops.secrets."traefik/env".path];
    extraOptions = [
      "--net=external"
      "--net=internal"
      "--network-alias=idp.lumiere.wtf"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.http-catchall.rule" = "hostregexp(`{host:.+}`)";
      "traefik.http.routers.http-catchall.entrypoints" = "web";
      "traefik.http.routers.http-catchall.middlewares" = "redirect-to-https@docker";
      "traefik.http.middlewares.redirect-to-https.redirectscheme.scheme" = "https";
      "traefik.http.middlewares.redir.redirectScheme.scheme" = "https";
    };
    volumes = [
      "/lumiere/data/docker/traefik/letsencrypt/:/letsencrypt/:rw"
      "/run/docker.sock:/var/run/docker.sock:ro"
    ];
  };
}
