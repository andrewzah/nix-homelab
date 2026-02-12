{config, ...}: {
  sops.secrets."redisp/env" = {};

  virtualisation.oci-containers.containers.redis = {
    autoStart = true;
    hostname = "redis";
    image = "docker.io/library/redis:8.4.0-alpine@sha256:6cbef353e480a8a6e7f10ec545f13d7d3fa85a212cdcc5ffaf5a1c818b9d3798";
    ports = ["6379"];
    environment.TZ = config.time.timeZone;
    extraOptions = [
      "--net=internal"

      "--health-cmd"
      "redis-cli ping | grep PONG"
      "--health-interval=5s"
      "--health-timeout=10s"
      "--health-retries=5"
      "--health-start-period=5s"
    ];
    volumes = ["/lumiere/data/docker/redis/data/:/data/:rw"];
  };

  # redis w/ password
  virtualisation.oci-containers.containers.redisp = {
    autoStart = true;
    hostname = "redisp";
    image = "docker.io/library/redis:8.4.0-alpine@sha256:6cbef353e480a8a6e7f10ec545f13d7d3fa85a212cdcc5ffaf5a1c818b9d3798";
    ports = ["6379"];
    environment.TZ = config.time.timeZone;
    cmd = [
      "sh"
      "-euc"
      ''
        /usr/local/bin/docker-entrypoint.sh --requirepass "$REDIS_PASSWORD_FILE"
      ''
    ];
    dependsOn = ["postgres" "redis"];
    environmentFiles = [config.sops.secrets."redisp/env".path];
    extraOptions = [
      "--net=internal"

      "--health-cmd"
      "redis-cli ping | grep PONG"
      "--health-interval=5s"
      "--health-timeout=10s"
      "--health-retries=5"
      "--health-start-period=5s"
    ];
    volumes = ["/lumiere/data/docker/redisp/data/:/data/:rw"];
  };
}
