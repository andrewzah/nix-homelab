{config, ...}: {
  #sops.secrets."ersat/env" = {};

  virtualisation.oci-containers.containers.ersatztv = {
    autoStart = true;
    image = "ghcr.io/ersatztv/ersatztv:2f0cd1eb6c2bf1207678e1d1967fe2432c80a740@sha256:edda3746b6794cbd44c9523dc2de49919b798862280c8c5ad9946df51b2373c9";
    ports = [
      "8409"
      "8410"
    ];
    environment = {
      TZ = "America/New_York";
      ETV_UI_PORT = "8409";
      ETV_STREAMING_PORT = "8410";
    };
    #environmentFiles = [config.sops.secrets."ersatztv/env".path];
    volumes = [
      "/lumiere/media/:/mnt/lumiere/media/:ro"
      "/lumiere/data/docker/ersatztv/config/:/config/:rw"
    ];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.ersatztv.rule" = "Host(`ersatztv.lumiere.wtf`)";
      "traefik.http.routers.ersatztv.entrypoints" = "websecure";
      "traefik.http.routers.ersatztv.tls.certresolver" = "porkbun";
      "traefik.http.routers.ersatztv.service" = "ersatztv";
      "traefik.http.services.ersatztv.loadbalancer.server.port" = "8409";

      "homepage.group" = "Media";
      "homepage.name" = "Ersatz TV";
      "homepage.href" = "https://ersatztv.lumiere.wtf";
      "homepage.description" = "Create TV channels from local media.";
    };
  };
}
