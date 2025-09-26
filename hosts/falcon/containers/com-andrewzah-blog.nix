{...}: {
  virtualisation.oci-containers.containers.com-andrewzah = {
    autoStart = true;
    image = "docker.io/andrewzah/com-andrewzah-blog:2025-09-25@sha256:7de7b04aa3d4b3ec7951173c80ba5cbf273d7558b65f853794f00577384a9f89";
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    ports = ["2020"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.com-andrewzah.rule" = "Host(`blog.andrewzah.com`)";
      "traefik.http.routers.com-andrewzah.entrypoints" = "websecure";
      "traefik.http.routers.com-andrewzah.tls.certresolver" = "cloudflare";
      "traefik.http.routers.com-andrewzah.service" = "com-andrewzah";
      "traefik.http.services.com-andrewzah.loadbalancer.server.port" = "2020";

      # anubis -- disable for now; see containers/anubis.nix
      #"traefik.http.routers.com-andrewzah.middlewares" = "anubis@docker";
    };
  };
}
