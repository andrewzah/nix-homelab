{...}: {
  virtualisation.oci-containers.containers.whoami = {
    autoStart = true;
    image = "docker.io/andrewzah/whoami:1.10.3";
    ports = ["8080"];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.whoami.rule" = "Host(`whoami.abare.party`)";
      "traefik.http.routers.whoami.entrypoints" = "websecure";
      "traefik.http.routers.whoami.tls.certresolver" = "generic";
      "traefik.http.routers.whoami.service" = "whoami";
      "traefik.http.services.whoami.loadbalancer.server.port" = "8080";
    };
  };
}
