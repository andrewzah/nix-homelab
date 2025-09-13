{config, ...}: {
  sops.secrets."silverbullet/env" = {};

  virtualisation.oci-containers.containers.silverbullet = {
    autoStart = true;
    image = "docker.io/zefhemel/silverbullet:v2@sha256:3b4291dad5d8e8521ca70818a3a12d7c06a5d0eac11c2a5d6a5060f067422bff";
    environment = {
      "SB_HOSTNAME" = "0.0.0.0";
      "SB_PORT" = "3000";
      "SB_SHELL_BACKEND" = "off";
      "SB_SHELL_WHITELIST" = "";
    };
    ports = ["3000"];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    environmentFiles = [config.sops.secrets."silverbullet/env".path];
    volumes = ["/blanka/silverbullet/space/:/space/:rw"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.silverbullet.rule" = "Host(`silverbullet.abare.party`)";
      "traefik.http.routers.silverbullet.entrypoints" = "websecure";
      "traefik.http.routers.silverbullet.tls.certresolver" = "generic";
      "traefik.http.routers.silverbullet.service" = "silverbullet";
      "traefik.http.services.silverbullet.loadbalancer.server.port" = "3000";
      "traefik.http.routers.silverbullet.middlewares" = "forwardauth";
    };
  };
}
