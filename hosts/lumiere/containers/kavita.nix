{config, ...}: {
  virtualisation.oci-containers.containers.kavita = {
    autoStart = true;
    image = "docker.io/jvmilazz0/kavita:nightly-0.8.9@sha256:cb6055ce997ac6f43e0b4badd11772dfd73716b3dceaba75448fcc486e288840";
    ports = ["5000:5000"];
    environment.TZ = config.time.timeZone;
    volumes = [
      "/lumiere/data/docker/kavita/config/:/kavita/config/:rw"
      "/lumiere/media/manga/:/manga/:ro"
      "/lumiere/media/manga-colored/:/manga-colored/:ro"
    ];
    extraOptions = ["--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.kavita.rule" = "Host(`kavita.lumiere.wtf`)";
      "traefik.http.routers.kavita.entrypoints" = "websecure";
      "traefik.http.routers.kavita.tls.certresolver" = "porkbun";
    };
  };
}
