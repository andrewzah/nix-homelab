{...}: {
  virtualisation.oci-containers.containers.com-andrewzah = {
    autoStart = true;
    image = "docker.io/andrewzah/com-andrewzah:2025-09-26@sha256:42f99f6aabea0323440712cc351e7da86b21a5c9a06a3a6472bec13eef20836a";
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
