{config, ...}: {
  sops.secrets."galene/env" = {};

  virtualisation.oci-containers.containers.galene = {
    user = "1000:1000";
    autoStart = false;
    image = "docker.io/andrewzah/galene:1.0@sha256:d69a4e71db88a136b6a2f1b2206c3d8e7354607640136f33cc0f35298082b7a0";
    ports = ["8443" "1194:1194"];
    environment = {
      TZ = config.time.timeZone;
      GALENE_DATA = "/data";
      GALENE_GROUPS = "/groups";
      GALENE_RECORDINGS = "/recordings";
      GALENE_INSECURE = "1";
    };
    environmentFiles = [config.sops.secrets."galene/env".path];
    volumes = [
      "/lumiere/data/docker/galene/data/:/data/:rw"
      "/lumiere/data/docker/galene/groups/:/groups/:rw"
      "/lumiere/data/docker/galene/recordings/:/recordings/:rw"
      "/lumiere/data/docker/galene/profiles/:/profiles/:rw"
    ];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.galene.rule" = "Host(`galene.andrewzah.com`)";
      "traefik.http.routers.galene.entrypoints" = "websecure";
      "traefik.http.routers.galene.tls.certresolver" = "cloudflare";
    };
  };
}
