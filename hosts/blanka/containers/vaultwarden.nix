{config, ...}: {
  sops.secrets."vaultwarden/env" = {};

  virtualisation.oci-containers.containers.vaultwarden = {
    autoStart = true;
    image = "docker.io/vaultwarden/server:1.35.1@sha256:1d43c6754a030861f960fd4dab47e1b33fc19f05bd5f8f597ab7236465a6f14b";
    ports = [
      "80"
      "3012:3012"
    ];
    environmentFiles = [config.sops.secrets."vaultwarden/env".path];
    volumes = ["/blanka/vaultwarden/:/data/:rw"];
    dependsOn = ["postgres"];
    extraOptions = [
      "--net=internal"
      "--net=external"

      "--health-cmd"
      "curl -f http://localhost:80"
      "--health-interval=5s"
      "--health-timeout=10s"
      "--health-retries=5"
      "--health-start-period=5s"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.vaultwarden-ui.rule" = "Host(`bit.abare.party`)";
      "traefik.http.routers.vaultwarden-ui.entrypoints" = "websecure";
      "traefik.http.routers.vaultwarden-ui.tls.certresolver" = "porkbun";
      "traefik.http.routers.vaultwarden-ui.service" = "vaultwarden-ui";
      "traefik.http.services.vaultwarden-ui.loadbalancer.server.port" = "80";

      # websockets
      "traefik.http.routers.vaultwarden-wss.rule" = "Host(`bit.abare.party`) && Path(`/notifications/hub`)";
      "traefik.http.routers.vaultwarden-wss.entrypoints" = "websecure";
      "traefik.http.routers.vaultwarden-wss.tls.certresolver" = "porkbun";
      "traefik.http.routers.vaultwarden-wss.service" = "vaultwarden-wss";
      "traefik.http.services.vaultwarden-wss.loadbalancer.server.port" = "3012";
    };
  };
}
