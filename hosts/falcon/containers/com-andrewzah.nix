{...}: {
  virtualisation.oci-containers.containers.com-andrewzah = {
    autoStart = true;
    image = "docker.io/andrewzah/com-andrewzah:latest@sha256:de0209fcba7080ad567543203dbe74c466918c6af06d3f6e55eecd69b1ac5711";
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

      # anubis -- disable for now; see containers/anubis.nix
      #"traefik.http.routers.com-andrewzah.middlewares" = "anubis@docker";
    };
  };
}
