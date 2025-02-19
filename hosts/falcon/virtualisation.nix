{...}: {
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
}
