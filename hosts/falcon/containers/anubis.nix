{...}: {
  virtualisation.oci-containers.containers.anubis = {
    autoStart = false;
    # tracking issues:
    # https://github.com/TecharoHQ/anubis/issues/974
    # https://github.com/TecharoHQ/anubis/issues/970

    image = "ghcr.io/techarohq/anubis:main@sha256:47f889145f29b9d0e6dffd999dcb3294c01621d8829c8f9a2991d2e7f0941867";
    environment = {
      BIND = ":8080";
      METRICS_BIND = ":9000";
      TARGET = " ";
      COOKIE_DOMAIN = "andrewzah.com";
      COOKIE_DYNAMIC_DOMAIN = "false";
      PUBLIC_URL = "https://anubis.andrewzah.com";
      WEBMASTER_EMAIL = "admin@andrewzah.com";
      #REDIRECT_DOMAINS = "andrewzah.com";
    };
    ports = ["8080"];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.anubis.rule" = "Host(`anubis.andrewzah.com`)";
      "traefik.http.routers.anubis.entrypoints" = "websecure";
      "traefik.http.routers.anubis.tls.certresolver" = "cloudflare";
      "traefik.http.routers.anubis.service" = "anubis";
      "traefik.http.services.anubis.loadbalancer.server.port" = "8080";
    };
  };
}
