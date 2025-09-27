{config, ...}: {
  sops.secrets."healthchecks/env" = {};

  virtualisation.oci-containers.containers.healthchecks = {
    autoStart = true;
    image = "docker.io/healthchecks/healthchecks:v3.11.2@sha256:cd8d65cabc30bccf96ed9741f6dcfe1a93521c754cbce7af155560fda3d54526";
    environment = {
    };
    ports = ["3000"];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    environmentFiles = [config.sops.secrets."healthchecks/env".path];
    volumes = ["/blanka/healthchecks/data/:/data/:rw"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.healthchecks.rule" = "Host(`healthchecks.abare.party`)";
      "traefik.http.routers.healthchecks.entrypoints" = "websecure";
      "traefik.http.routers.healthchecks.tls.certresolver" = "generic";
      "traefik.http.routers.healthchecks.service" = "healthchecks";
      "traefik.http.services.healthchecks.loadbalancer.server.port" = "3000";
    };
  };
}
