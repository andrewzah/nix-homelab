{config, ...}: let
  image = "ghcr.io/windmill-labs/windmill:1.601.0@sha256:d18f1ef1bff9c6b7e04ccbeea734e985ecc7ccaeb069bd62cd3f4410c4f82879";
in {
  sops.secrets."windmill/env" = {};
  sops.secrets."postgres/creds/windmill/database" = {};
  sops.secrets."postgres/creds/windmill/password" = {};
  sops.secrets."postgres/creds/windmill/username" = {};

  virtualisation.oci-containers.containers.windmill = {
    autoStart = true;
    inherit image;
    ports = [
      "8000"
      "3001"
      "2525"
    ];
    environment = {
      TZ = config.time.timeZone;
      MODE = "server";
    };
    environmentFiles = [config.sops.secrets."windmill/env".path];
    dependsOn = ["traefik" "postgres"];
    extraOptions = [
      "--net=external"
      "--net=internal"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.windmill.rule" = "Host(`windmill.lumiere.wtf`)";
      "traefik.http.routers.windmill.entrypoints" = "websecure";
      "traefik.http.routers.windmill.tls.certresolver" = "porkbun";
      "traefik.http.routers.windmill.service" = "windmill";
      "traefik.http.services.windmill.loadbalancer.server.port" = "8000";

      # websockets
      "traefik.http.routers.windmill-wss.rule" = "Host(`.zah.rocks`) && Path(`/ws`)";
      "traefik.http.routers.windmill-wss.tls.certresolver" = "porkbun";
      "traefik.http.routers.windmill-wss.entrypoints" = "websecure";
      "traefik.http.routers.windmill-wss.service" = "windmill-wss";
      "traefik.http.services.windmill-wss.loadbalancer.server.port" = "3001";
    };
  };

  virtualisation.oci-containers.containers.windmill-worker = {
    autoStart = true;
    inherit image;
    environment = {
      TZ = config.time.timeZone;
      MODE = "worker";
      WORKER_GROUP = "default";
    };
    dependsOn = ["postgres"];
    environmentFiles = [config.sops.secrets."windmill/env".path];
    extraOptions = [
      "--net=internal"
    ];
    volumes = ["/lumiere/data/docker/windmill/worker-cache/:/tmp/windmill/cache/:rw"];
  };
}
