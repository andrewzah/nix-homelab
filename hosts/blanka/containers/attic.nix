{config, ...}: {
  sops.secrets."attic/env" = {};
  sops.secrets."attic/config" = {};

  virtualisation.oci-containers.containers.attic = {
    autoStart = false;

    image = "docker.io/andrewzah/attic:2025-07-17";
    ports = ["58080:8080" "8080"];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    environmentFiles = [config.sops.secrets."attic/env".path];
    volumes = [
      "${config.sops.secrets."attic/config".path}:/var/attic/server.toml:ro"
      "/blanka/attic/data/:/data/:rw"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.attic.rule" = "Host(`attic.abare.party`)";
      "traefik.http.routers.attic.entrypoints" = "websecure";
      "traefik.http.routers.attic.tls.certresolver" = "porkbun";
      "traefik.http.routers.attic.service" = "attic";
      "traefik.http.services.attic.loadbalancer.server.port" = "8080";
    };
  };
}
