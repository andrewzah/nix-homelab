{config, ...}: {
  virtualisation.oci-containers.containers.tunarr = {
    autoStart = true;
    image = "docker.io/chrisbenincasa/tunarr:1.0.9@sha256:0a630e2461577aa36529d6df8e12c50d3167e67272939b842c20d2cf2a5ffea8";
    ports = ["34800:8000"];
    environment = {
      TZ = "America/New_York";
    };
    volumes = [
      "/lumiere/data/docker/tunarr/config/:/config/tunarr/:rw"
    ];
  };
}
