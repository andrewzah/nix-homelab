{config, ...}: {
  sops.secrets."jellyfin/env" = {};

  virtualisation.oci-containers.containers.jellyfin = {
    autoStart = true;
    image = "docker.io/linuxserver/jellyfin:10.11.5@sha256:ed5dc797d12089271e0e61a740cbf9626c4e513400ca2d96c54d35500eeb907c";
    ports = [
      "8096/tcp"
      "8096:8096/tcp"
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
      "/lumiere/media/:/mnt/lumiere/media/:rw"
      "/lumiere/data/docker/jellyfin/config/:/config/:rw"
      "/lumiere/data/docker/jellyfin/cache/:/cache/:rw"
    ];
    dependsOn = ["traefik"];
    extraOptions = [
      "--net=external"
      "--net=media"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.jellyfin.rule" = "Host(`jellyfin.lumiere.wtf`)";
      "traefik.http.routers.jellyfin.entrypoints" = "websecure";
      "traefik.http.routers.jellyfin.tls.certresolver" = "porkbun";
      "traefik.http.routers.jellyfin.service" = "jellyfin";
      "traefik.http.services.jellyfin.loadbalancer.server.port" = "8096";
    };
    devices = ["nvidia.com/gpu=all"];
  };
}
