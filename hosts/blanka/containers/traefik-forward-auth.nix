{config, ...}: {
  sops.secrets."traefik-forward-auth/env" = {};

  virtualisation.oci-containers.containers.forwardauth = {
    image = "docker.io/mesosphere/traefik-forward-auth:v3.2.1@sha256:7b0159e59f7b4d2ffd484371fb44f0502434991e2b8070c85460b319a8bfc035";
    hostname = "forwardauth";
    autoStart = false;
    environmentFiles = [config.sops.secrets."traefik-forward-auth/env".path];
    ports = ["4181"];
    extraOptions = [
      "--net=external"
      "--net=internal"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.forwardauth.entrypoints" = "websecure";
      "traefik.http.routers.forwardauth.rule" = "Path(`/_oauth`)";
      "traefik.http.routers.forwardauth.middlewares" = "traefik-forward-auth";
      "traefik.http.middlewares.forwardauth.forwardauth.address" = "http://forwardauth:4181";
      "traefik.http.middlewares.forwardauth.forwardauth.authResponseHeaders" = "X-Forwarded-User";
      "traefik.http.middlewares.forwardauth.forwardauth.trustForwardHeader" = "true";
      "traefik.http.routers.forwardauth.tls" = "true";
      "traefik.http.routers.forwardauth.tls.certresolver" = "generic";
    };
  };
}
