{config, ...}: {
  sops.secrets."zitadel/env" = {};

  virtualisation.oci-containers.containers.zitadel = {
    autoStart = false;
    image = "ghcr.io/zitadel/zitadel:v4.7.6@sha256:de025f0e7aa95c5780afa1f9f913f9522a4a21fae7abc8a8912f8002a1dd5d0b";
    ports = [
      "8080"
      "3000"
    ];
    cmd = ["start-from-init" "--masterkeyFromEnv"];
    environment.TZ = "America/New_York";
    environmentFiles = [config.sops.secrets."zitadel/env".path];
    volumes = ["/lumiere/data/docker/zitadel/data/:/data/:rw"];
    dependsOn = ["traefik" "postgres"];
    extraOptions = [
      "--net=external"
      "--net=internal"

      "--health-cmd"
      "/app/zitadel ready"
      "--health-interval=10s"
      "--health-timeout=60s"
      "--health-retries=5"
      "--health-start-period=10s"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.zitadel.rule" = "Host(`idp.lumiere.wtf`)";
      "traefik.http.routers.zitadel.entrypoints" = "websecure";
      "traefik.http.routers.zitadel.tls.certresolver" = "porkbun";
      "traefik.http.routers.zitadel.service" = "zitadel";
      "traefik.http.services.zitadel.loadbalancer.server.port" = "3000";
    };
  };
}
