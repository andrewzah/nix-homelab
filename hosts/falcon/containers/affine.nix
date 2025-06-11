{config,...}: let
  image = "ghcr.io/toeverything/affine-graphql:stable@sha256:75dae00b81e32b1ef6d671134bce7d718c7d4d3c7cb5d3d220cd744e2765f75a";
  environmentFiles = [config.sops.secrets."affine/env".path];
  volumes = [
    "/eagle/data/docker/affine/storage:/root/.affine/storage/:rw"
    "/eagle/data/docker/affine/config:/root/.affine/config/:rw"
  ];
in {
  sops.secrets."affine/env" = {};

  virtualisation.oci-containers.containers.affine = {
    inherit image environmentFiles volumes;

    autoStart = false;
    environment."AFFINE_INDEXER_ENABLED" = "false";
    cmd = [
      "sh"
      "-c"
      "node ./scripts/self-host-predeploy.js && node ./dist/main.js"];
    extraOptions = [
      "--net=external"
      "--net=internal"
      "--network-alias=affine.zah.rocks"
    ];
    dependsOn = ["traefik" "postgres" "redis"];
    ports = ["3010"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.affine.rule" = "Host(`affine.zah.rocks`)";
      "traefik.http.routers.affine.entrypoints" = "websecure";
      "traefik.http.routers.affine.tls.certresolver" = "generic";
    };
  };

  virtualisation.oci-containers.containers.affine-migrate = {
    inherit image environmentFiles volumes;

    autoStart = false;
    cmd = ["sh" "-c" "node" "./scripts/self-host-predeploy.js"];
    extraOptions = ["--net=internal"];
    dependsOn = ["postgres"];
  };
}
