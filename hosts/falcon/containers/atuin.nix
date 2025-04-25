{config, ...}: {
  sops.secrets."atuin/env" = {};

  virtualisation.oci-containers.containers.atuin = {
    autoStart = false;
    image = "ghcr.io/atuinsh/atuin:v18.5.0@sha256:f784866f13d51568c0d1673b3c64c7660508469aac7c87f1b559c2482c1d01aa";
    ports = ["8888"];
    cmd = ["server" "start"];
    environment = {
      RUST_LOG = "INFO";
    };
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
