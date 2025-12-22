{config, ...}: {
  sops.secrets."jellyfin/env" = {};

  virtualisation.oci-containers.containers.jellyfin = {
    autoStart = false;
    image = "docker.io/jellyfin/jellyfin:2025121505@sha256:81721f1a09eab9e459eaea1c080b53308eb464c7c0d4b135a616561f8c4b6c23";
    ports = [
      "8096/tcp"
      "7359:7359/udp"
    ];
    environment = {
      TZ = "America/New_York";
      PUID = "1000";
      PGID = "1000";

      JELLYFIN_PublishedServerUrl = "https://jellyfin.lumiere.wtf";

      NVIDIA_VISIBLE_DEVICES = "all";
      NVIDIA_DRIVER_CAPABILITIES = "all";
    };
    environmentFiles = [config.sops.secrets."jellyfin/env".path];
    volumes = [
      "/lumiere/media/:/mnt/lumiere/media/:ro"
      "/lumiere/data/docker/jellyfin/config/:/config/:rw"
      "/lumiere/data/docker/jellyfin/cache/:/cache/:rw"
    ];
    dependsOn = ["traefik"];
    extraOptions = [
      "--runtime=nvidia"
      "--gpus=all"
      "--net=external"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.jellyfin.rule" = "Host(`jellyfin.lumiere.wtf`)";
      "traefik.http.routers.jellyfin.entrypoints" = "websecure";
      "traefik.http.routers.jellyfin.tls.certresolver" = "generic";
      "traefik.http.routers.jellyfin.service" = "jellyfin";
      "traefik.http.services.jellyfin.loadbalancer.server.port" = "8096";
    };
  };
}
