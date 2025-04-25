{config, ...}: {
  sops.secrets."knot/env" = {};

  virtualisation.oci-containers.containers.atuin = {
    autoStart = false;
    image = "docker.io/andrewzah/knot:0.1.0@sha256:644ba631b926c1e649e76a937c608c7e914e5965fae473312c7603022e9f58a5";
    ports = ["22" "5555"];
    cmd = ["server" "start"];
    environment = {
      RUST_LOG = "INFO";
    };
    environmentFiles = [config.sops.secrets."atuin/env".path];
    volumes = ["/eagle/data/docker/knot1/:/home/git/:rw"];
    dependsOn = ["traefik" "postgres"];
    extraOptions = ["--net=internal" "--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.knot1.rule" = "Host(`knot1.bebop.lol`)";
      "traefik.http.routers.knot1.entrypoints" = "websecure";
      "traefik.http.routers.knot1.tls.certresolver" = "generic";
    };
  };
}
