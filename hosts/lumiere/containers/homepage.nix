{config, ...}: {
  #sops.secrets."homepage/env" = {};

  virtualisation.oci-containers.containers.homepage = {
    autoStart = true;
    image = "ghcr.io/gethomepage/homepage:dev@sha256:a44cc71200afb26d35b0478008b37399d82ff0c73f81be4088f1d857dffbb4d7";
    ports = ["3000" "31300:3000"];
    environment = {
      HOMEPAGE_ALLOWED_HOSTS = "lumiere.wtf,localhost:31300";
      PUID = "1000";
      PGID = "1000";
    };
    #environmentFiles = [config.sops.secrets."homepage/env".path];
    volumes = ["/lumiere/data/docker/homepage/config/:/config/:rw"];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    labels = {
      #"traefik.enable" = "true";
      #"traefik.http.routers.homepage.rule" = "Host(`homepage.lumiere.wtf`)";
      #"traefik.http.routers.homepage.entrypoints" = "websecure";
      #"traefik.http.routers.homepage.tls.certresolver" = "porkbun";
    };
  };
}
