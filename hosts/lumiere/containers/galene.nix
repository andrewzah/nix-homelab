{config, ...}: {
  sops.secrets."galene/env" = {};

  virtualisation.oci-containers.containers.galene = {
    autoStart = true;
    #user = "1000:1000";
    image = "";
    ports = []; # STUN/TURN ?
    environment.TZ = config.time.timeZone;
    environmentFiles = [config.sops.secrets."galene/env".path];
    volumes = ["/lumiere/data/docker/galene/config/:/config/:rw"];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external" "--net=internal"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.galene.rule" = "Host(`galene.andrewzah.com`)";
      "traefik.http.routers.galene.entrypoints" = "websecure";
      "traefik.http.routers.galene.tls.certresolver" = "cloudflare";
    };
  };
}
