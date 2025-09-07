{pkgs, ...}: {
  virtualisation = {
    docker.rootless.enable = true;
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
      "docker-mc-proxy.service"
      "docker-mc-survival.service"
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      ${pkgs.docker}/bin/docker network inspect internal || ${pkgs.docker}/bin/docker network create internal
      ${pkgs.docker}/bin/docker network inspect external || ${pkgs.docker}/bin/docker network create external
    '';
  };
}
