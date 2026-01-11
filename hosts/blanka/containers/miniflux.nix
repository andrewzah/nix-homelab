{config, ...}: {
  sops.secrets."miniflux/env" = {};

  virtualisation.oci-containers.containers.miniflux = {
    autoStart = true;
    image = "docker.io/miniflux/miniflux:2.2.16-distroless@sha256:82af042befc298b89cc4488910ec8bead3632a1070de7b72ee6a117df41b71f3";
    ports = ["8080"];
    dependsOn = ["traefik" "postgres"];
    extraOptions = ["--net=external" "--net=internal"];
    environmentFiles = [config.sops.secrets."miniflux/env".path];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.miniflux.rule" = "Host(`miniflux.abare.party`)";
      "traefik.http.routers.miniflux.entrypoints" = "websecure";
      "traefik.http.routers.miniflux.tls.certresolver" = "porkbun";
    };
  };
}
