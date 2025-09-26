{...}: {
  virtualisation.oci-containers.containers.com-andrewzah = {
    autoStart = true;
    image = "docker.io/andrewzah/com-andrewzah:2025-09-27@sha256:72bde57a91b299699e52eb37ab3261fca7e73c3d117a73feeddb8d4d61430972";
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
