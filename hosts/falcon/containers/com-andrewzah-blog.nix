{...}: {
  virtualisation.oci-containers.containers.com-andrewzah-blog = {
    autoStart = true;
    image = "docker.io/andrewzah/com-andrewzah-blog:2025-09-27@sha256:98687fde32f556219fcdd3c4e9aa630320199c5676a3b40c0c28186cff576696";
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
