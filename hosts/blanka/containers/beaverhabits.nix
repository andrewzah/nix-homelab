{config, ...}: {
  sops.secrets."beaverhabits/env" = {};

  virtualisation.oci-containers.containers.beaverhabits = {
    autoStart = true;
    user = "1000:1000";
    image = "docker.io/daya0576/beaverhabits:sha-73095b0@sha256:2562eafaa4ef955a3c7a8b071a3da44168191dddf3232959d39303b5e519cd37";
    ports = ["8080"];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    environmentFiles = [config.sops.secrets."beaverhabits/env".path];
    volumes = [
      "/lumiere/data/docker/beaverhabits/data/:/app/.user/:rw"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.beaverhabits.rule" = "Host(`habits.abare.party`)";
      "traefik.http.routers.beaverhabits.entrypoints" = "websecure";
      "traefik.http.routers.beaverhabits.tls.certresolver" = "porkbun";
    };
  };
}
