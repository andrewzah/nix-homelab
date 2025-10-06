{config, ...}: {
  sops.secrets."linkding/env" = {};

  virtualisation.oci-containers.containers.linkding = {
    autoStart = true;
    image = "ghcr.io/sissbruecker/linkding:1.44.0-plus-alpine@sha256:eb8928109e22b528496b580073be344fb50c7e2c448d5427b336eb48f38ac6b3";
    ports = ["9090"];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    environmentFiles = [config.sops.secrets."linkding/env".path];
    volumes = ["/blanka/linkding/data/:/etc/linkding/data/:rw"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.linkding.rule" = "Host(`linkding.abare.party`)";
      "traefik.http.routers.linkding.entrypoints" = "websecure";
      "traefik.http.routers.linkding.tls.certresolver" = "porkbun";
      "traefik.http.routers.linkding.service" = "linkding";
      "traefik.http.services.linkding.loadbalancer.server.port" = "9090";
    };
  };
}
