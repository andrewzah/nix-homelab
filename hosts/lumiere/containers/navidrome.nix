{config, ...}: {
  sops.secrets."navidrome/env" = {};
  virtualisation.oci-containers.containers.navidrome = {
    autoStart = true;
    user = "1000:1000";
    image = "docker.io/deluan/navidrome:0.59.0@sha256:4edc8a1de3e042f30b78a478325839f4395177eb8201c27543dccc0eba674f23";
    ports = ["4533"];
    environment.TZ = config.time.timeZone;
    environmentFiles = [config.sops.secrets."navidrome/env".path];
    volumes = [
      "/lumiere/data/docker/navidrome/data/:/data/:rw"
      "/lumiere/media/music/:/music/:ro"
    ];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external" "--net=internal"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.navidrome.rule" = "Host(`navidrome.lumiere.wtf`)";
      "traefik.http.routers.navidrome.entrypoints" = "websecure";
      "traefik.http.routers.navidrome.tls.certresolver" = "porkbun";
    };
  };
}
