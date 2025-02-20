{config, ...}: {
  # TODO: templating?
  sops.secrets."vaultwarden/DATABASE_URL" = {};

  virtualisation.oci-containers.containers.vaultwarden = {
    autoStart = true;
    image = "docker.io/vaultwarden/server:1.33.2-alpine@sha256:63cce7624f655f83ad5bab66ef62bc3e3327116b068704bfbbda5d0c1b3003be";
    ports = ["80" "3012"];
    environment = {
      DOMAIN = "https://bit.zah.rocks";
      WEBSOCKET_ENABLED = "true";
      SIGNUPS_ALLOWED = "false";
    };
    environmentFiles = [
      config.sops.secrets."vaultwarden/DATABASE_URL".path
    ];
    volumes = [
      "/eagle/data/docker/bitwarden-rs/:/data/:rw"
    ];
    dependsOn = [ "traefik" "postgres" ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.vaultwarden-ui.rule" = "Host(`bit.zah.rocks`)";
      "traefik.http.routers.vaultwarden-ui.entrypoints" = "websecure";
      "traefik.http.routers.vaultwarden-ui.tls.certresolver" = "generic";
      "traefik.http.routers.vaultwarden-ui.service" = "vaultwarden-ui";
      "traefik.http.services.vaultwarden-ui.loadbalancer.server.port" = "80";

      # websockets
      "traefik.http.routers.vaultwarden-wss.rule" = "Host(`bit.zah.rocks`) && Path(`/notifications/hub`)";
      "traefik.http.routers.vaultwarden-wss.tls.certresolver" = "generic";
      "traefik.http.routers.vaultwarden-wss.entrypoints" = "websecure";
      "traefik.http.routers.vaultwarden-wss.service" = "vaultwarden-wss";
      "traefik.http.services.vaultwarden-wss.loadbalancer.server.port" = "3012";
    };
  };
}
