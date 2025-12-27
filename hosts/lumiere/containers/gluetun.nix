{config, ...}: {
  sops.secrets."gluetun/env" = {};

  virtualisation.oci-containers.containers.gluetun = {
    autoStart = true;
    image = "docker.io/qmcgaw/gluetun:v3.41@sha256:6b54856716d0de56e5bb00a77029b0adea57284cf5a466f23aad5979257d3045";
    capabilities.NET_ADMIN = true;
    capabilities.NET_RAW = true;
    ports = [
      "8888:8888/tcp"
      "8388:8388/tcp"
      "8388:8388/udp"
    ];
    environment = {
      TZ = "America/New_York";
    };
    environmentFiles = [config.sops.secrets."gluetun/env".path];
    volumes = [
      "/lumiere/data/docker/gluetun/config/:/gluetun/:rw"
      "/lumiere/data/docker/gluetun/logs/:/var/log/gluetun/:rw"
    ];
    extraOptions = [
      "--device=/dev/net/tun:/dev/net/tun"
    ];
  };
}
