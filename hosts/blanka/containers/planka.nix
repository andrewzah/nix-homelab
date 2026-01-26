{config, ...}: {
  sops.secrets."planka/env" = {};

  virtualisation.oci-containers.containers.planka = {
    autoStart = true;
    user = "1000:1000";
    image = "ghcr.io/plankanban/planka:1.26.3@sha256:42c5e7a546d1cf082080fee06a922d1839157f479941a8a7c98e9d6a75c6d373";
    ports = ["1337"];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    environmentFiles = [config.sops.secrets."planka/env".path];
    volumes = [
      "/blanka/planka/public/:/app/public/:rw"
      "/blanka/planka/private/:/app/private/:rw"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.planka.rule" = "Host(`planka.abare.party`)";
      "traefik.http.routers.planka.entrypoints" = "websecure";
      "traefik.http.routers.planka.tls.certresolver" = "porkbun";
    };
  };
}
