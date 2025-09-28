{...}: {
  virtualisation.oci-containers.containers.com-andrewzah-blog = {
    autoStart = true;
    image = "docker.io/andrewzah/com-andrewzah-blog:2025-09-29@sha256:d5c75ac3577bbd65a76a6271e5720cdfa72cb4f0203a3aedcbfca1dfb5d4afd5";
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
