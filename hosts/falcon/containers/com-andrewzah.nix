{...}: {
  virtualisation.oci-containers.containers.com-andrewzah = {
    autoStart = true;
    image = "docker.io/andrewzah/com-andrewzah:latest@sha256:a28fb83b08d2a2569a77d7c8ab8e2937ee116d7d8abeb1da3b512e91f538c71d";
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
