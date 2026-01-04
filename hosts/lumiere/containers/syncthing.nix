{config, ...}: {
  virtualisation.oci-containers.containers.syncthing = {
    autoStart = true;
    image = "docker.io/linuxserver/syncthing:2.0.12@sha256:b2dbc42f95154986ae3578256f3fa9612fa7e930184d823aa56192b478fa0b8a";
    ports = [
      "8384"
      "22000:22000/tcp"
      "22000:22000/udp"
      "21027:21027/udp"
    ];
    environment = {
      TZ = "America/New_York";
      PUID = "1000";
      PGID = "1000";
    };
    volumes = [
      "/lumiere/data/docker/syncthing/config/:/config/:rw"
      "/lumiere/data/docker/syncthing/data/:/data/:rw"
      "/lumiere/data/docker/syncthing/data/andrew/:/data/andrew/:rw"
    ];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.syncthing.rule" = "Host(`syncthing.lumiere.wtf`)";
      "traefik.http.routers.syncthing.entrypoints" = "websecure";
      "traefik.http.routers.syncthing.tls.certresolver" = "porkbun";
      "traefik.http.routers.syncthing.service" = "syncthing";
      "traefik.http.services.syncthing.loadbalancer.server.port" = "8384";
    };
  };
}
