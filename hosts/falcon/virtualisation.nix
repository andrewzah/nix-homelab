{pkgs, ...}: {
  virtualisation = {
    docker.rootless.enable = true;
    docker.rootless.setSocketVariable = true;
    docker.autoPrune.enable = true;
    containerd.enable = true;

    oci-containers.backend = "docker"; # defaults to podman
  };

  environment.sessionVariables = {
    DOCKER_HOST = "unix:///run/docker.sock"; # fix for rootless docker
  };

  systemd.services.create-docker-networks = {
    description = "Create external and internal docker networks manually";
    after = ["network.target"];
    wants = ["network-online.target"];
    script = ''
      ${pkgs.docker}/bin/docker network inspect internal || ${pkgs.docker}/bin/docker network create internal
      ${pkgs.docker}/bin/docker network inspect external || ${pkgs.docker}/bin/docker network create external
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    wantedBy = ["multi-user.target"];
  };
}
