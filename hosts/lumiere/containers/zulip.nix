{config, ...}: {
  sops.secrets."zulip/env" = {};

  virtualisation.oci-containers.containers.zulip = {
    autoStart = false;
    image = "docker.io/zulip/docker-zulip:11.5-0@sha256:423e96e151a7bb8f90795eb97e24933a92bd7b5e217349398c5018f18a183bc9";
    ports = ["80" "25"];
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
    };
  };
}
