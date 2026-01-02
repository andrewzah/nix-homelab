{...}: {
  virtualisation.oci-containers.containers.baikal = {
    autoStart = true;
    image = "docker.io/ckulka/baikal:nginx@sha256:1a901125d121a3e414cda87c617bd322c57ae86b9d2aedbff7b3a7ac84bb23aa";
    ports = ["80"];
    environment = {
      BAIKAL_SERVERNAME = "dav.abare.party";
    };
    extraOptions = ["--net=external"];
    volumes = [
      "/blanka/baikal/data/:/var/www/baikal/Specific/:rw"
      "/blanka/baikal/config/:/var/www/baikal/config/:rw"
    ];
    dependsOn = ["traefik"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.baikal.rule" = "Host(`dav.abare.party`)";
      "traefik.http.routers.baikal.entrypoints" = "websecure";
      "traefik.http.routers.baikal.tls.certresolver" = "porkbun";
    };
  };
}
