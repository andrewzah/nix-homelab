{config, ...}: {
  sops.secrets."postgres/env" = {};

  virtualisation.oci-containers.containers.postgres = {
    autoStart = true;
    hostname = "postgres";
    image = "docker.io/library/postgres:15-alpine";
    ports = ["5432:5432"];
    environment = {
      PGDATA = "/var/lib/postgresql/data";
    };
    environmentFiles = [config.sops.secrets."postgres/env".path];
    extraOptions = [
      "--net=internal"

      #TODO:
      #"--health-cmd"
      #"pg_isready -d ''${POSTGRES_DB} -U ''${POSTGRES_USER}"]
      #start_period: 20s
      #interval: 30s
      #retries: 5
      #timeout: 5s
    ];
    volumes = [
      "/eagle/data/docker/postgres15/:/var/lib/postgresql/data/:rw"
    ];
  };

  #systemd.services."init-postgres-dbs" = {
  #  enable = true;
  #  after = ["docker-postgres"];

  #  serviceConfig = {
  #    Type = "oneshot";
  #    RemainAfterExit = true;
  #  };

  #  script = ''
  #  '';
  #};
}
