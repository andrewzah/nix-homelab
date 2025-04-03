{config, ...}: {
  sops.secrets."zitadel/env" = {};
  sops.secrets."postgres/creds/zitadel/username" = {};
  sops.secrets."postgres/creds/zitadel/password" = {};
  sops.secrets."postgres/creds/zitadel/database" = {};

  virtualisation.oci-containers.containers.zitadel = {
    autoStart = false;
    hostname = "zitadel";
    image = "ghcr.io/zitadel/zitadel:v2.71.6@sha256:a8e5070eac8199eec707f3dfd010e16cc19959e433cd0685e7919aeab471eaa2";
    cmd = [
      "start-from-init"
      "--masterkeyFromEnv"
      "--tlsMode" "external"
    ];
    environmentFiles = [config.sops.secrets."zitadel/env".path];
    dependsOn = ["postgres"];
    ports = ["8080"];
    extraOptions = [
      "--net=internal"
      "--net=external"

      "--health-cmd"
      "/app/zitadel ready"
      "--health-interval=5s"
      "--health-timeout=10s"
      "--health-retries=15"
      "--health-start-period=5"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.zitadel.rule" = "Host(`idp.zah.rocks`)";
      "traefik.http.routers.zitadel.entrypoints" = "websecure";
      "traefik.http.routers.zitadel.tls.certresolver" = "generic";
      "traefik.http.routers.zitadel.service" = "zitadel";
      "traefik.http.services.zitadel.loadbalancer.server.port" = "8080";
      "traefik.http.services.zitadel.loadBalancer.servers" = "h2c://zitadel:8080";
    };
  };
  # https://github.com/oauth2-proxy/oauth2-proxy
  # https://github.com/zitadel/zitadel/discussions/5537
  # https://zitadel.com/docs/self-hosting/manage/reverseproxy/reverse_proxy
}
