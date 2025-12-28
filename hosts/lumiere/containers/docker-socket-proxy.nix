{config, ...}: {
  virtualisation.oci-containers.containers.docker-socket-proxy = {
    autoStart = true;
    image = "ghcr.io/tecnativa/docker-socket-proxy:v0.4.1@sha256:1c211b210cf155392544face6e2c2ebfe626f97f5f1e4eea94ed2ebe2be7bc55";
    ports = ["127.0.0.1:2375:2375"];
    environment = {
      CONTAINERS = "1";
      SERVICES = "1";
      TASKS = "1";
      POST = "0";
    };
    volumes = ["/var/run/docker.sock:/var/run/docker.sock:ro"];
  };
}
