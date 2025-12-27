{config, ...}: {
  sops.secrets."arr/env" = {};
  sops.secrets."transmission/env" = {};

  virtualisation.oci-containers.containers = {
    transmission = {
      autoStart = true;
      dependsOn = ["gluetun"];
      image = "lscr.io/linuxserver/transmission:latest@sha256:9e5157459da3272d5dcbca2db84f3823dd9daa0f166b963c5d51899098b17035";
      ports = [];
      extraOptions = ["--network=container:gluetun"];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/New_York";
      };
      environmentFiles = [config.sops.secrets."transmission/env".path];
      volumes = [
        "/lumiere/data/docker/transmission/config/:/config/:rw"
        "/lumiere/media/downloads:/downloads/:rw"
      ];
    };
  };
}
