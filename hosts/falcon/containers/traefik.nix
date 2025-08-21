{config, ...}: {
  sops.secrets."traefik/env" = {};

  virtualisation.oci-containers.containers.traefik = {
    autoStart = true;
    image = "docker.io/library/traefik:v3.4.1@sha256:cd40ab7bc1f047731d5b22595203812343efcb6538014c4e93221cfc3a77217a";
    cmd = [
      "--api.insecure=false"
      "--api.dashboard=false"

      "--log.level=INFO" # ERROR default

      ## providers
      "--providers.docker=true"
      "--providers.docker.exposedbydefault=false"
      #"--providers.file=true"
      #"--providers.file.watch=true"
      #"--providers.file.filename=/etc/traefik/rules.toml"

      ## entrypoints
      "--entrypoints.web.address=:80"
      "--entrypoints.websecure.address=:443"
      "--entrypoints.ssh.address=:2222"
      #"--entryPoints.servatrice.address=:4747/tcp"
      #"--entryPoints.servatrice-wss.address=:4748"
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
      "2222:2222"
      "80:80"
      "443:443"
      #"4747:4747"
      #"4748:4748"
      "8080:8080"
      "11371:11371"
    ];
    environmentFiles = [config.sops.secrets."traefik/env".path];
    extraOptions = [
      "--net=external"
      "--net=internal"
      "--network-alias=idp.zah.rocks"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.http-catchall.rule" = "hostregexp(`{host:.+}`)";
      "traefik.http.routers.http-catchall.entrypoints" = "web";
      "traefik.http.routers.http-catchall.middlewares" = "redirect-to-https@docker";
      "traefik.http.middlewares.redirect-to-https.redirectscheme.scheme" = "https";
      "traefik.http.middlewares.redir.redirectScheme.scheme" = "https";
      # anubis
      "traefik.http.middlewares.anubis.forwardauth.address" = "http://anubis:8080/.within.website/x/cmd/anubis/api/check";
    };
    volumes = [
      "/eagle/data/docker/traefik/letsencrypt/:/letsencrypt/:rw"
      "/run/docker.sock:/var/run/docker.sock:ro"
    ];
  };
}
