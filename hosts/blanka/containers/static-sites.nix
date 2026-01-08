{...}: {
  virtualisation.oci-containers.containers.com-andrewzah = {
    autoStart = true;
    image = "docker.io/andrewzah/com-andrewzah:2026-01-08@sha256:2bc287779b8d8a2c9f76cbb3c2d2e1fbaa50cf9031587b4a944fba3bdb3cdbd8";
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    ports = ["2020"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.com-andrewzah.rule" = "Host(`andrewzah.com`)";
      "traefik.http.routers.com-andrewzah.entrypoints" = "websecure";
      "traefik.http.routers.com-andrewzah.tls.certresolver" = "cloudflare";
      ## anubis -- disable for now; see containers/anubis.nix
      #"traefik.http.routers.com-andrewzah.service" = "com-andrewzah";
      #"traefik.http.services.com-andrewzah.loadbalancer.server.port" = "2020";
      #"traefik.http.routers.com-andrewzah.middlewares" = "anubis@docker";
    };
  };

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

  virtualisation.oci-containers.containers.club-nixseoul = {
    autoStart = false;
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
