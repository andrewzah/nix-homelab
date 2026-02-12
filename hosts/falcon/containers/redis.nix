{...}: {
  virtualisation.oci-containers.containers.redis = {
    autoStart = true;
    hostname = "redis";
    image = "docker.io/library/redis:7.4.4-alpine@sha256:ee9e8748ace004102a267f7b8265dab2c618317df22507b89d16a8add7154273";
    ports = ["6379"];
    environment.TZ = "America/New_York";
    dependsOn = ["postgres" "redis"];
    extraOptions = [
      "--net=internal"

      "--health-cmd"
      "redis-cli ping | grep PONG"
      "--health-interval=5s"
      "--health-timeout=10s"
      "--health-retries=5"
      "--health-start-period=5s"
    ];
    volumes = ["/eagle/data/docker/redis/data/:/data/:rw"];
  };
}
