{config, ...}: {
  sops.secrets."glance/env" = {};

  virtualisation.oci-containers.containers.glance = {
    autoStart = true;
    image = "docker.io/glanceapp/glance:v0.8.3@sha256:1fa252b1651c061cbe7a023326b314248bb820f81ee89a89970347b83684414c";
    ports = ["8080"];
    environmentFiles = [config.sops.secrets."glance/env".path];
    dependsOn = ["traefik" "postgres"];
    extraOptions = ["--net=internal" "--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.glance.rule" = "Host(`dash.zah.rocks`)";
      "traefik.http.routers.glance.entrypoints" = "websecure";
      "traefik.http.routers.glance.tls.certresolver" = "generic";
    };
    volumes = [
      "/eagle/data/docker/glance/config/:/app/config/:rw"
      "/eagle/data/docker/glance/assets/:/app/assets/:rw"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
    ];
  };
}
