{config, ...}: {
  sops.secrets."atuin/env" = {};

  virtualisation.oci-containers.containers.atuin = {
    autoStart = true;
    image = "ghcr.io/atuinsh/atuin:2e26f34@sha256:e1ca2601ad4c9ee00a19b588cbf82ce494243613eee55d88d28ef8e9347e404d ";
    environment = {
      RUST_LOG = "INFO";
    };
    ports = ["8888"];
    cmd = ["server" "start"];
    environmentFiles = [config.sops.secrets."atuin/env".path];
    dependsOn = ["traefik" "postgres"];
    extraOptions = ["--net=internal" "--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.atuin.rule" = "Host(`atuin.zah.rocks`)";
      "traefik.http.routers.atuin.entrypoints" = "websecure";
      "traefik.http.routers.atuin.tls.certresolver" = "generic";
    };
  };
}
