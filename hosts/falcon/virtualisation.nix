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
    after = [ "network.target" ];
    wants = [ "network-online.target" ];
    script = ''
      ${pkgs.docker}/bin/docker network create internal &2>/dev/null || true
      ${pkgs.docker}/bin/docker network create external &2>/dev/null || true
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    wantedBy = [ "multi-user.target" ];
  };

  # need to make networks manually in order
  # for containers to connect by hostname
  # e.g. postgres
  #system.activationScripts.mkDockerNetworks = ''
  #  ${pkgs.docker}/bin/docker network create internal &2>/dev/null || true
  #  ${pkgs.docker}/bin/docker network create external &2>/dev/null || true
  #'';
}
