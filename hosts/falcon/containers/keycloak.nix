{config, ...}: {
  sops.secrets."keycloak/env" = {};

  virtualisation.oci-containers.containers.keycloak = {
    autoStart = true;
    image = "docker.io/keycloak/keycloak:26.1@sha256:044a457e04987e1fff756be3d2fa325a4ef420fa356b7034ecc9f1b693c32761";
    cmd = [
      "start"
      "--hostname=https://idp.zah.rocks"
      "--hostname-admin=https://idp.zah.rocks"
      "--proxy-headers=forwarded"
      "--http-enabled=true"
      "--db=postgres"
      "--log=console"
    ];
    environmentFiles = [config.sops.secrets."keycloak/env".path];
    #volumes = ["/eagle/data/docker/goatcounter/:/data/:rw"];
    dependsOn = ["traefik" "postgres" "openldap"];
    extraOptions = ["--net=internal" "--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.keycloak.rule" = "Host(`idp.zah.rocks`)";
      "traefik.http.routers.keycloak.entrypoints" = "websecure";
      "traefik.http.routers.keycloak.tls.certresolver" = "generic";
    };
    ports = ["8080"];
  };
}
