{...}: {
  virtualisation.oci-containers.containers.baikal = {
    autoStart = true;
    image = "docker.io/ckulka/baikal:nginx@sha256:22d5b8b5db962b41826cea4996f600833d300aad3d6bb17f57db611800b347e1";
    ports = ["80"];
    environment = {
      BAIKAL_SERVERNAME = "dav.zah.rocks";
    };
    extraOptions = ["--net=external"];
    volumes = [
      "/eagle/data/docker/baikal/specific/:/var/www/baikal/Specific/:rw"
      "/eagle/data/docker/baikal/config/:/var/www/baikal/config/:rw"
    ];
    dependsOn = ["traefik"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.baikal.rule" = "Host(`dav.zah.rocks`)";
      "traefik.http.routers.baikal.entrypoints" = "websecure";
      "traefik.http.routers.baikal.tls.certresolver" = "generic";
    };
  };
}
