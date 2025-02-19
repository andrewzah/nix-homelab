{...}: {
  ##################
  ### virt setup ###
  ##################

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

  ##################
  ### containers ###
  ##################

  virtualisation.oci-containers.containers = {
    whoami = {
      autoStart = true;
      ports = ["8080"];
      image = "docker.io/andrewzah/whoami:1.10.3";
      environmentFiles = [ "/var/run/secrets/example-key" ];
    };

    traefik = {
      autoStart = true;
      image = "docker.io/library/traefik:v3.1.4@sha256:6215528042906b25f23fcf51cc5bdda29e078c6e84c237d4f59c00370cb68440";
      ports = [
        "22:22"
        "80:80"
        "443:443"
        "8080:8080"
        "11371:11371"
      ];
      ## TODO: gandi / porkbun dns challenge secrets
      #environmentFiles = [ "/var/run/secrets/example-key" ];
    };
  };
}
