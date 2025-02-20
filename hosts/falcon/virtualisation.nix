{pkgs, ...}: {
  virtualisation = {
    docker.rootless.enable = true;
    docker.rootless.setSocketVariable = true;
    docker.autoPrune.enable = true;
    containerd.enable = true;
  };

  environment.sessionVariables = {
    # for rootless docker
    DOCKER_HOST = "unix:///run/docker.sock";
  };

  # defaults to podman
  virtualisation.oci-containers.backend = "docker";

  # need to make networks manually in order
  # for containers to connect by hostname
  # e.g. postgres
  system.activationScripts.mkDockerNetworks = ''
    ${pkgs.docker}/bin/docker network create internal &2>/dev/null || true
    ${pkgs.docker}/bin/docker network create external &2>/dev/null || true
  '';
}
