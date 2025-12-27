{...}: {
  virtualisation.oci-containers.containers.scrutiny = {
    autoStart = true;
    image = "ghcr.io/analogj/scrutiny:master-omnibus@sha256:a53021b1d74fb3c63a81f9f9272bafffd4bdfdc43bd19ac9b60c57185a63fe04";
    ports = ["8080" "8086"];
    capabilities.SYS_RAWIO = true;
    environment = {
      TZ = "America/New_York";
      COLLECTOR_CRON_SCHEDULE = "0 4 * * *";
    };
    volumes = [
      "/lumiere/data/docker/scrutiny/config/:/opt/scrutiny/config/:rw"
      "/lumiere/data/docker/scrutiny/influxdb2/:/opt/scrutiny/influxdb/:rw"
      "/run/udev:/run/udev:ro"
    ];
    devices = [
      "/dev/sda"
      "/dev/sdb"
      "/dev/sdc"
      "/dev/sdd"
      "/dev/sde"
      "/dev/sdf"
      "/dev/sdg"
      "/dev/sdh"
    ];
  };
}
