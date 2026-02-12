{config, ...}: {
  sops.secrets."zulip/env" = {};

  virtualisation.oci-containers.containers.zulip = {
    autoStart = true;
    image = "ghcr.io/zulip/zulip-server:11.5-2@sha256:699259272824daf404d302ae2412b127771ff3bdc96f6406635942894994833e";
    ports = [
      "25"
      "80"
    ];
    environment.TZ = config.time.timeZone;
    environmentFiles = [config.sops.secrets."zulip/env".path];
    volumes = ["/lumiere/data/docker/zulip/data/:/data/:rw"];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external" "--net=internal"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.zulip.rule" = "Host(`zulip.andrewzah.com`)";
      "traefik.http.routers.zulip.entrypoints" = "websecure";
      "traefik.http.routers.zulip.tls.certresolver" = "cloudflare";
      "traefik.http.routers.zulip.service" = "zulip";
      "traefik.http.services.zulip.loadbalancer.server.port" = "80";
      "traefik.http.routers.zulip.middlewares" = "zulip-headers";
      "traefik.http.middlewares.zulip-headers.headers.customrequestheaders.X-Forwarded-Proto" = "https";
    };
  };
}
