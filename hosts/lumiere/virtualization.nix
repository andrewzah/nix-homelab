{pkgs, ...}: {
  virtualisation = {
    docker.rootless.enable = true;
    docker.rootless.daemon.settings = {
      # for prometheus
      "metrics-addr" = "127.0.0.1:9323";

      # for homepage.dev
      #"hosts" = [
      #  "tcp://0.0.0.0:2375"
      #  "unix:///var/run/docker.sock"
      #];
    };
    docker.autoPrune.enable = true;
    containerd.enable = true;

    oci-containers.backend = "docker"; # defaults to podman
  };

  environment.sessionVariables = {
    DOCKER_HOST = "unix:///run/docker.sock"; # fix for rootless docker
  };

  systemd.services.create-docker-networks = {
    description = "Create docker networks manually";
    after = ["docker.service"];
    wants = ["docker.service"];
    wantedBy = [
      "docker-traefik.service"
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      ${pkgs.docker}/bin/docker network inspect internal \
        || ${pkgs.docker}/bin/docker network create internal

      ${pkgs.docker}/bin/docker network inspect external \
        || ${pkgs.docker}/bin/docker network create external

      ${pkgs.docker}/bin/docker network inspect socket_proxy \
        || ${pkgs.docker}/bin/docker network create socket_proxy
    '';
  };
}
