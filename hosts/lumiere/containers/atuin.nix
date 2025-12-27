{config, ...}: {
  sops.secrets."atuin/env" = {};

  virtualisation.oci-containers.containers.atuin = {
    autoStart = true;
    image = "ghcr.io/atuinsh/atuin:8a010fe@sha256:1ddb3d32995acb77ee52655dd2be28a956be597cd586bbac30ca6a3d2f251877";
    environment.RUST_LOG = "INFO";
    ports = ["8888"];
    cmd = ["server" "start"];
    environmentFiles = [config.sops.secrets."atuin/env".path];
    dependsOn = ["traefik" "postgres"];
    extraOptions = ["--net=internal" "--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.atuin.rule" = "Host(`atuin.lumiere.wtf`)";
      "traefik.http.routers.atuin.entrypoints" = "websecure";
      "traefik.http.routers.atuin.tls.certresolver" = "porkbun";
    };
  };
}
