{config, ...}: {
  sops.secrets."monica/env" = {};

  virtualisation.oci-containers.containers.monica = {
    autoStart = false;
    image = "lscr.io/linuxserver/monica:v4.1.2-ls79@sha256:ff10e0acd4894f2d7f3b3b89fe87ec3adae509292e88873a9a9f64857618435d";
    ports = ["80"];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external" "--net=internal"];
    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = config.time.timeZone;
    };
    environmentFiles = [config.sops.secrets."monica/env".path];
    volumes = ["/blanka/monica/config/:/config/:rw"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.monica.rule" = "Host(`prm.abare.party`)";
      "traefik.http.routers.monica.entrypoints" = "websecure";
      "traefik.http.routers.monica.tls.certresolver" = "porkbun";
    };
  };
}
