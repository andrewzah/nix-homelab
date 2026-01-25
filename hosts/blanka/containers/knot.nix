{config, ...}: {
  sops.secrets."maedub/env" = {};

  virtualisation.oci-containers.containers.maedub = {
    autoStart = false;
    image = "docker.io/andrewzah/knot:0.11.0-alpha@sha256:94267add7ca92bef460c9f8f507a797c12c020c97a9c1ed3f16a09077379cb76";
    ports = ["22" "5555"];
    environment = {
      RUST_LOG = "INFO";
    };
    environmentFiles = [config.sops.secrets."maedub/env".path];
    volumes = ["/blanka/maedub/data/:/data/git/:rw"];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.maedub.rule" = "Host(`maedub.abare.party`)";
      "traefik.http.routers.maedub.entrypoints" = "websecure";
      "traefik.http.routers.maedub.tls.certresolver" = "porkbun";
    };
  };
}
