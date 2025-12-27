{config, ...}: {
  sops.secrets."mealie/env" = {};

  virtualisation.oci-containers.containers.mealie = {
    autoStart = true;
    image = "ghcr.io/mealie-recipes/mealie:v3.8.0@sha256:8642de0227e76f8de5fedbb606c45a653cd007ecc5fe746931d4eb969420399d";
    ports = ["9000"];
    environmentFiles = [config.sops.secrets."mealie/env".path];
    volumes = [
      "/lumiere/data/docker/mealie/data/:/app/data/:rw"
    ];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.mealie.rule" = "Host(`mealie.lumiere.wtf`)";
      "traefik.http.routers.mealie.entrypoints" = "websecure";
      "traefik.http.routers.mealie.tls.certresolver" = "porkbun";
    };
  };
}
