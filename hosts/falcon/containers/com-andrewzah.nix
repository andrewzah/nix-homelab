{...}: {
  virtualisation.oci-containers.containers.com-andrewzah = {
    autoStart = true;
    image = "docker.io/andrewzah/com-andrewzah:latest@sha256:268b60c6ac3fda9b998006e6eee9159e6c2d45af842c2dc343ebda996204bd07";
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    ports = ["2020"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.com-andrewzah.rule" = "Host(`andrewzah.com`)";
      "traefik.http.routers.com-andrewzah.entrypoints" = "websecure";
      "traefik.http.routers.com-andrewzah.tls.certresolver" = "cloudflare";
      "traefik.http.routers.com-andrewzah.service" = "com-andrewzah";
      "traefik.http.services.com-andrewzah.loadbalancer.server.port" = "2020";
    };
  };
}
