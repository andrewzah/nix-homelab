{...}: {
  virtualisation.oci-containers.containers.com-andrewzah = {
    autoStart = true;
    image = "docker.io/andrewzah/com-andrewzah:2025-09-26@sha256:7917bc332854960f0a4e39cfb49cd8b6b1f904c0426ff063dbdcb5fd4e723c24";
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    ports = ["2020"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.com-andrewzah.rule" = "Host(`andrewzah.com`)";
      "traefik.http.routers.com-andrewzah.entrypoints" = "websecure";
      "traefik.http.routers.com-andrewzah.tls.certresolver" = "cloudflare";
      # "traefik.http.routers.com-andrewzah.service" = "com-andrewzah";
      # "traefik.http.services.com-andrewzah.loadbalancer.server.port" = "2020";

      #  anubis -- disable for now; see containers/anubis.nix
      # "traefik.http.routers.com-andrewzah.middlewares" = "anubis@docker";
    };
  };
}
