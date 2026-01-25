{config, ...}: {
  sops.secrets."maedub/env" = {};

  virtualisation.oci-containers.containers.maedub = {
    autoStart = false;
    image = "docker.io/andrewzah/knot:0.11.0-unstable-26-1-25@sha256:bc9ce3028730aac5324484f1f95716a6dcb17fcc00a7a53dfaa93510a7635f32";
    ports = ["22" "5555"];
    environment = {
      RUST_LOG = "INFO";
    };
    environmentFiles = [config.sops.secrets."maedub/env".path];
    volumes = ["/blanka/maedub/data/:/data/git/:rw"];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.maedub.rule" = "Host(`maedub.abare.party`)";
      "traefik.http.routers.maedub.entrypoints" = "websecure";
      "traefik.http.routers.maedub.tls.certresolver" = "porkbun";
    };
  };
}
