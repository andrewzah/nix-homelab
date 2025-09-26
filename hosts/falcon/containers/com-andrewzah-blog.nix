{...}: {
  virtualisation.oci-containers.containers.com-andrewzah-blog = {
    autoStart = true;
    image = "docker.io/andrewzah/com-andrewzah-blog:2025-09-25@sha256:7de7b04aa3d4b3ec7951173c80ba5cbf273d7558b65f853794f00577384a9f89";
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    ports = ["2020"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.com-andrewzah-blog.rule" = "Host(`blog.andrewzah.com`)";
      "traefik.http.routers.com-andrewzah-blog.entrypoints" = "websecure";
      "traefik.http.routers.com-andrewzah-blog.tls.certresolver" = "cloudflare";

      # "traefik.http.routers.com-andrewzah-blog.service" = "com-andrewzah";
      # "traefik.http.services.com-andrewzah-blog.loadbalancer.server.port" = "2020";
      # anubis -- disable for now; see containers/anubis.nix
      #"traefik.http.routers.com-andrewzah-blog.middlewares" = "anubis@docker";
    };
  };
}
