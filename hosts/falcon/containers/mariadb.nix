{pkgs, config, ...}: {
  sops.secrets."mariadb/env" = {};

  virtualisation.oci-containers.containers.mariadb = {
    autoStart = true;
    hostname = "mariadb";
    image = "docker.io/library/mariadb:11.7.2-ubi";
    ports = ["3306"];
    environmentFiles = [config.sops.secrets."mariadb/env".path];
    extraOptions = [
      "--net=internal"

      "--health-cmd"
      "healthcheck.sh --connect --innodb_initialized"
      "--health-interval=5s"
      "--health-timeout=10s"
      "--health-retries=5"
      "--health-start-period=5s"
    ];
    volumes = ["/eagle/data/docker/mariadb/:/var/lib/mysql/:rw"];
  };
}
