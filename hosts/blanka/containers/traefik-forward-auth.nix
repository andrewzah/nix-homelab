{config, ...}: {
  sops.secrets."traefik-forward-auth/env" = {};

  virtualisation.oci-containers.containers.traefik-forward-auth = {
    autoStart = true;
    hostname = "forwardauth";
    image = "docker.io/mesosphere/traefik-forward-auth@sha256:";
    environmentFiles = [config.sops.secrets."traefik-forward-auth/env".path];
    ports = ["4181"];
    extraOptions = [
      "--net=internal"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.forwardauth.entrypoints" = "websecure";
      "traefik.http.routers.forwardauth.rule" = "Path(`/_oauth`)";
      "traefik.http.routers.forwardauth.middlewares" = "traefik-forward-auth";
      "traefik.http.middlewares.traefik-forward-auth.forwardauth.address" = "http://forwardauth:4181";
      "traefik.http.middlewares.traefik-forward-auth.forwardauth.authResponseHeaders" = "X-Forwarded-User";
      "traefik.http.middlewares.traefik-forward-auth.forwardauth.trustForwardHeader" = "true";
      "traefik.http.routers.traefik-forward-auth.tls" = "true";
      "traefik.http.routers.traefik-forward-auth.tls.certresolver" = "cloudflare";
    };
  };
}
