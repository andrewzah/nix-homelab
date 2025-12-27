{...}: {
  virtualisation.oci-containers.containers.prometheus = {
    autoStart = true;
    image = "docker.io/library/prometheus:v3.8.1@sha256:2b6f734e372c1b4717008f7d0a0152316aedd4d13ae17ef1e3268dbfaf68041b";
    ports = ["9090"];
    dependsOn = ["postgres"];
    extraOptions = ["--net=internal"];
    volumes = [
      "/lumiere/data/docker/prometheus/data/:/prometheus/:rw"
      "/lumiere/data/docker/prometheus/config/:/etc/prometheus/:rw"
    ];
  };
}
