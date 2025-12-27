{config, ...}: {
  sops.secrets."keycloak/env" = {};

  virtualisation.oci-containers.containers.keycloak = {
    autoStart = true;
    ports = ["8080"];
    image = "quay.io/keycloak/keycloak:26.4.7@sha256:9409c59bdfb65dbffa20b11e6f18b8abb9281d480c7ca402f51ed3d5977e6007";
    cmd = [
      "start"
      "--hostname=https://idp.lumiere.wtf"
      "--hostname-admin=https://idp.lumiere.wtf"
      "--http-enabled=true"
      "--db=postgres"
      "--log=console"
      "--log-level=DEBUG"
      #"--proxy-headers=xforwarded"
    ];
    environmentFiles = [config.sops.secrets."keycloak/env".path];
    dependsOn = ["traefik" "postgres"];
    extraOptions = ["--net=internal" "--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.keycloak.rule" = "Host(`idp.lumiere.wtf`)";
      "traefik.http.routers.keycloak.entrypoints" = "websecure";
      "traefik.http.routers.keycloak.tls.certresolver" = "porkbun";
    };
  };
}
