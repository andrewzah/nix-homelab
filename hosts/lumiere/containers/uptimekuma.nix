{config, ...}: {
  virtualisation.oci-containers.containers.uptimekuma = {
    autoStart = true;
    image = "docker.io/louislam/uptime-kuma:2.1.0-beta-slim.0@sha256:9aec713997a014fe5fa5fad4cddde319ed2cb36606001b62304e73844004cee8";
    ports = ["3001"];
    environment = {
      TZ = config.time.timeZone;
      DATA_DIR = "/app/data";
      UPTIME_KUMA_HOST = "0.0.0.0";
      UPTIME_KUMA_PORT = "3001";
    };
    volumes = ["/lumiere/data/docker/uptimekuma/data/:/app/data/:rw"];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.uptimekuma.rule" = "Host(`uptimekuma.lumiere.wtf`)";
      "traefik.http.routers.uptimekuma.entrypoints" = "websecure";
      "traefik.http.routers.uptimekuma.tls.certresolver" = "porkbun";
    };
  };
}
