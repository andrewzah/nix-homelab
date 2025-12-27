{config, ...}: {
  sops.secrets."pocketid/env" = {};

  virtualisation.oci-containers.containers.pocketid = {
    autoStart = true;
    image = "ghcr.io/pocket-id/pocket-id:v2@sha256:8c9d376c0d7c8118c691d3582b36c4448012b9a0a8a7b2c8161a93eea204e6dd";
    ports = ["1411"];
    environment.TZ = "America/New_York";
    environmentFiles = [config.sops.secrets."pocketid/env".path];
    volumes = ["/lumiere/data/docker/pocketid/data/:/app/data/:rw"];
    dependsOn = ["traefik"];
    extraOptions = [
      "--net=external"
      "--health-cmd"
      "/app/pocket-id healthcheck"
      "--health-interval=1m30s"
      "--health-timeout=5s"
      "--health-retries=2"
      "--health-start-period=10s"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.pocketid.rule" = "Host(`idp.lumiere.wtf`)";
      "traefik.http.routers.pocketid.entrypoints" = "websecure";
      "traefik.http.routers.pocketid.tls.certresolver" = "porkbun";
    };
  };
}
