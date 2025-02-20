{...}: {
  virtualisation.oci-containers.containers.postgres = {
    autoStart = true;
    hostname = "postgres";
    image = "docker.io/library/postgres:15-alpine";
    ports = ["5432:5432"];
    environment = {
      PGDATA = "/var/lib/postgresql/data";
    };
    extraOptions = [ "--net=internal" ];
    volumes = [
      "/eagle/data/docker/postgres15/:/var/lib/postgresql/data/:rw"
    ];
  };
}
