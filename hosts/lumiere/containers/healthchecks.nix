{config, ...}: {
  sops.secrets."healthchecks/env" = {};

  virtualisation.oci-containers.containers.healthchecks = {
    autoStart = true;
    image = "docker.io/healthchecks/healthchecks:v3.13@sha256:228137b2fe50f8c4b3f6f1a8ef3970cc74ee84b56075bcf79381fc35a50b295d";
    environment = {};
    ports = ["8000"];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    environmentFiles = [config.sops.secrets."healthchecks/env".path];
    volumes = ["/lumiere/data/docker/healthchecks/data/:/data/:rw"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.healthchecks.rule" = "Host(`healthchecks.lumiere.wtf`)";
      "traefik.http.routers.healthchecks.entrypoints" = "websecure";
      "traefik.http.routers.healthchecks.tls.certresolver" = "porkbun";
    };
  };
}
