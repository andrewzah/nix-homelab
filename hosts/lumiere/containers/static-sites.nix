{...}: {
  virtualisation.oci-containers.containers.org-scfgc = {
    autoStart = true;
    image = "docker.io/andrewzah/org-scfgc:latest@sha256:a36ddaadd8181d70df608f2676efe835026d7c01ac3dad073ed50d4e1977ebe9";
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.org-scfgc.rule" = "Host(`scfgc.org`)";
      "traefik.http.routers.org-scfgc.entrypoints" = "websecure";
      "traefik.http.routers.org-scfgc.tls.certresolver" = "generic";
    };
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    ports = ["2020"];
  };

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

  virtualisation.oci-containers.containers.club-nixseoul = {
    autoStart = true;
    image = "docker.io/andrewzah/club-nixseoul:latest@sha256:4d33ba90ef795a0a3f10ec64a61805393377a1de488a55e81aed895f834d0cfd";
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.club-nixseoul.rule" = "Host(`nixseoul.club`)";
      "traefik.http.routers.club-nixseoul.entrypoints" = "websecure";
      "traefik.http.routers.club-nixseoul.tls.certresolver" = "generic";
    };
    extraOptions = ["--net=external"];
    ports = ["2020"];
  };
}
