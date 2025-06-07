{...}: {
  virtualisation.oci-containers.containers.com-andrewzah = {
    autoStart = true;
    image = "docker.io/andrewzah/com-andrewzah:latest@sha256:367c64cf0c2285c5e89220c8d74588dbf19e64141b8d5a79a0c60711b94a033f";
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
