{config, ...}: {
  sops.secrets."traefik/env" = {};

  virtualisation.oci-containers.containers.traefik = {
    autoStart = false;
    image = "docker.io/library/traefik:v3.5.2@sha256:f0abbbd11ced29754d4d188c29e9320b613481ec162b6ea5d3a8b6bdd8e5fa54";
    cmd = [
      "--global.checkNewVersion=true"
      "--global.sendAnonymousUsage=false"

      "--api.insecure=true"
      "--api.dashboard=true"
      "--log.level=DEBUG"

      "--providers.docker=true"
      "--providers.docker.exposedbydefault=false"

      "--entrypoints.web.address=:80"
      "--entrypoints.websecure.address=:443"
      "--entrypoints.ssh.address=:2222"

      ## redirections
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
      #"--certificatesresolvers.porkbun.acme.dnsChallenge.delayBeforeCheck=0"
      #"--certificatesresolvers.porkbun.acme.dnsChallenge.resolvers=1.1.1.1:53"

      ## cloudflare resolver
      "--certificatesresolvers.cloudflare.acme.storage=/letsencrypt/cloudflare-acme.json"
      "--certificatesresolvers.cloudflare.acme.email=admin@andrewzah.com"
      "--certificatesresolvers.cloudflare.acme.dnschallenge=true"
      "--certificatesresolvers.cloudflare.acme.dnsChallenge.provider=cloudflare"
      "--certificatesresolvers.cloudflare.acme.dnsChallenge.delayBeforeCheck=0"
      "--certificatesresolvers.cloudflare.acme.dnsChallenge.resolvers=1.1.1.1:53"
      #"--certificatesResolvers.cloudflare.acme.caServer=https://acme-staging-v02.api.letsencrypt.org/directory"
    ];
    ports = [
      "80:80"
      "443:443"
      "8080:8080"
    ];
    environmentFiles = [config.sops.secrets."traefik/env".path];
    extraOptions = [
      "--net=external"
      "--net=internal"
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
      "/blanka/traefik/letsencrypt/:/letsencrypt/:rw"
      "/run/docker.sock:/var/run/docker.sock:ro"
    ];
  };
}
