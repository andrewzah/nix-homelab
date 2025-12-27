{config, ...}: {
  sops.secrets."pocketid/env" = {};

  virtualisation.oci-containers.containers.pocketid = {
    autoStart = true;
    image = "ghcr.io/pocket-id/pocket-id:next-distroless@sha256:4380c78ade4f77c6e352ef5bad641100f01bf4e70c03d2ab2bfa081e8def6997";
    ports = ["1411"];
    environment = {
      TZ = "America/New_York";
      ETV_UI_PORT = "8409";
      ETV_STREAMING_PORT = "8410";
    };
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
      "traefik.http.routers.pocketid.service" = "pocketid";
      "traefik.http.services.pocketid.loadbalancer.server.port" = "8409";
    };
  };
}
