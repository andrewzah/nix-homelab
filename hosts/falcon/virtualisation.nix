{...}: {
  virtualisation.oci-containers.containers = {
    whoami = {
      ports = ["8080"];
      image = "docker.io/andrewzah/whoami:1.10.3";
      environmentFiles = [];
    };
  };
}
