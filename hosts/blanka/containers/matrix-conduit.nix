{config, ...}: {
  sops.secrets."matrix-conduit/env" = {};

  virtualisation.oci-containers.containers.matrix-conduit = {
    autoStart = false;
    image = "docker.io/matrixconduit/matrix-conduit:29aca1748844aa00161bc20553d091bd748bd46b@sha256:6d1e9fa99a42c7b76f17218ae9e8243c6eae7866c30c8791a01a324b9049bf5e";
    ports = ["6167"];
    environmentFiles = [config.sops.secrets."matrix-conduit/env".path];
    volumes = ["/blanka/matrix-conduit/data/:/var/lib/matrix-conduit/:rw"];
    extraOptions = ["--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.matrix-conduit.rule" = "Host(`matrix.abare.party`)";
      "traefik.http.routers.matrix-conduit.entrypoints" = "websecure";
      "traefik.http.routers.matrix-conduit.tls.certresolver" = "porkbun";
    };
  };
}
