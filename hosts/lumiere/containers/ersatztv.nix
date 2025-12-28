{config, ...}: {
  virtualisation.oci-containers.containers.ersatztv = {
    autoStart = true;
    image = "ghcr.io/ersatztv/ersatztv:2f0cd1eb6c2bf1207678e1d1967fe2432c80a740@sha256:edda3746b6794cbd44c9523dc2de49919b798862280c8c5ad9946df51b2373c9";
    ports = [
      "8409:8409"
      "8410:8410"
    ];
    environment = {
      TZ = "America/New_York";
      ETV_UI_PORT = "8409";
      ETV_STREAMING_PORT = "8410";
    };
    volumes = [
      "/lumiere/media/:/mnt/lumiere/media/:ro"
      "/lumiere/data/docker/ersatztv/config/:/config/:rw"
    ];
  };
}
