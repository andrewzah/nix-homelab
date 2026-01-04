{
  pkgs,
  config,
  ...
}: {
  sops.secrets."postgres/env" = {};
  sops.secrets."postgres/envSystemd" = {};
  sops.secrets."postgres/username" = {};
  sops.secrets."postgres/password" = {};
  sops.secrets."postgres/database" = {};

  virtualisation.oci-containers.containers.postgres = {
    autoStart = true;
    hostname = "postgres";
    image = "docker.io/library/postgres:17-alpine";
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
      #start_period: 2s
      #interval: 3s
      #retries: 15
      #timeout: 2s
    ];
    volumes = [
      "/lumiere/data/docker/postgres17/:/var/lib/postgresql/data/:rw"
    ];
  };

  systemd.services."init-postgres-dbs" = {
    enable = true;
    wants = [
      "docker.service"
      "docker-postgres.service"
    ];
    after = [
      "docker.service"
      "docker-postgres.service"
    ];
    wantedBy = [
      "docker-atuin.service"
      "docker-docmost.service"
      "docker-keycloak.service"
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      EnvironmentFile = config.sops.secrets."postgres/envSystemd".path;
    };

    script = ''
            cmd="${pkgs.docker}/bin/docker exec -u postgres postgres psql -U $PG_ROOT_USERNAME -d $PG_ROOT_DATABASE  --echo-all --echo-errors --host localhost"

            for service_dir in "$PG_CREDS_DIR"/*/; do
              if [[ -d "$service_dir" ]]; then

                u=$(cat "$service_dir/username")
                p=$(cat "$service_dir/password")
                d=$(cat "$service_dir/database")

                $cmd -v ON_ERROR_STOP=1 <<-EOSQL
                  DO
                  \$do$
                  BEGIN
                    IF EXISTS ( SELECT FROM pg_catalog.pg_roles WHERE rolname = '$u') THEN
                        RAISE NOTICE 'Role "$u" already exists. Skipping.';
                    ELSE
                        CREATE ROLE $u LOGIN PASSWORD '$p';
                    END IF;
                  END
                  \$do$;

                  SELECT 'CREATE DATABASE $d ENCODING "UNICODE"'
                  WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$d')\gexec

                  ALTER DATABASE $d OWNER TO $u;
                  GRANT ALL PRIVILEGES ON DATABASE $d TO $u;
      EOSQL
              fi
            done
    '';
  };
}
