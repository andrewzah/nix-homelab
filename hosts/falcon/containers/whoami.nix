{...}: let
  fqdn = "whoami.zah.rocks";
in {
  virtualisation.oci-containers.containers.whoami = {
    autoStart = true;
    ports = ["8080"];
    image = "docker.io/andrewzah/whoami:1.10.3";
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.whoami.rule" = "Host(`${fqdn}`)";
      "traefik.http.routers.atuin.tls.certresolver" = "generic";
    };
  };
}
