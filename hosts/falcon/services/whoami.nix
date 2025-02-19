{...}: {
  virtualisation.oci-containers.containers.whoami = {
    autoStart = true;
    ports = ["8080"];
    image = "docker.io/andrewzah/whoami:1.10.3";
  };
}
