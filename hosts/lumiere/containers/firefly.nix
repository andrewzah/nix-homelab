{config, ...}: {
  sops.secrets."firefly/env" = {};
  sops.secrets."firefly-pico/env" = {};

  virtualisation.oci-containers.containers.firefly = {
    autoStart = true;
    image = "docker.io/fireflyiii/core:version-6.4.14@sha256:b3958eb028ab85d9026a59af6fc25665088c714eb92fcd6cb4fb0f83a428335c";
    ports = ["8080"];
    environment.TZ = config.time.timeZone;
    environmentFiles = [config.sops.secrets."firefly/env".path];
    volumes = ["/lumiere/data/docker/firefly/uploads/:/var/www/html/storage/upload/:rw"];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external" "--net=internal"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.firefly.rule" = "Host(`firefly.lumiere.wtf`)";
      "traefik.http.routers.firefly.entrypoints" = "websecure";
      "traefik.http.routers.firefly.tls.certresolver" = "porkbun";
    };
  };

  ## streamlined web frontend consuming firefly's rest api
  virtualisation.oci-containers.containers.firefly-pico = {
    autoStart = true;
    image = "docker.io/cioraneanu/firefly-pico:1.9.3@sha256:60dcfc2467e66d047ef1298a86dd5ed0fb45464c604e7ccd088597131e350b40";
    ports = ["3000"];
    environment.TZ = config.time.timeZone;
    environmentFiles = [config.sops.secrets."firefly-pico/env".path];
    dependsOn = ["traefik" "firefly"];
    extraOptions = ["--net=external" "--net=internal"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.firefly.rule" = "Host(`firefly-pico.lumiere.wtf`)";
      "traefik.http.routers.firefly.entrypoints" = "websecure";
      "traefik.http.routers.firefly.tls.certresolver" = "porkbun";
    };
  };
}
