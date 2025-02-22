{config, ...}: {
  virtualisation.oci-containers.containers.redis = {
    autoStart = true;
    hostname = "redis";
    image = "docker.io/library/redis:7.4.2-alpine@sha256:02419de7eddf55aa5bcf49efb74e88fa8d931b4d77c07eff8a6b2144472b6952";
    ports = ["6379"];
    environment = {
      TZ = "America/New_York";
    };
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
    volumes = [ "/eagle/data/docker/redis/data/:/data/:rw" ];
  };
}
