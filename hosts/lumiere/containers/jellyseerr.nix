{
  config,
  DOMAIN,
  ...
}: {
  sops.secrets."jellyseerr/env" = {};

  virtualisation.oci-containers.containers.jellyseerr = {
    autoStart = true;
    user = "1000:1000";
    image = "ghcr.io/fallenbagel/jellyseerr:sha-9ca63ba@sha256:3b94c53eda6c58629c18ec42574d8e7c0d67f2bef9a6fd5616956574d88a4630";
    ports = ["5055:5055"];
    environment = {
      TZ = config.time.timeZone;
      PORT = "5055";
    };
    environmentFiles = [config.sops.secrets."jellyseerr/env".path];
    volumes = [
      "/lumiere/data/docker/jellyseerr/config/:/app/config/:rw"
    ];
    dependsOn = ["traefik"];
    extraOptions = [
      "--net=media"
      "--net=external"

      "--health-cmd"
      "wget --no-verbose --tries=1 --spider http://localhost:5055/api/v1/status || exit 1"
      "--health-start-period=20s"
      "--health-interval=5s"
      "--health-timeout=15s"
      "--health-retries=3"
    ];
  };
}
