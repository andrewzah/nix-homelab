{...}: {
  virtualisation.oci-containers.containers.anubis = {
    autoStart = true;
    image = "ghcr.io/techarohq/anubis:main@sha256:47f889145f29b9d0e6dffd999dcb3294c01621d8829c8f9a2991d2e7f0941867";
    environment = {
      BIND = "0.0.0.0:8080";
      TARGET = " ";
      REDIRECT_DOMAINS = "andrewzah.com";
      COOKIE_DOMAIN = "andrewzah.com";
      PUBLIC_URL = "https://anubis.andrewzah.com";
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
