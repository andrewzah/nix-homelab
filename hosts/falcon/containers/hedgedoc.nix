{config,...}: {
  sops.secrets."hedgedoc/env" = {};

  virtualisation.oci-containers.containers.hedgedoc = {
    autoStart = true;
    image = "docker.io/linuxserver/hedgedoc:1.10.3@sha256:049cc4dd0e6eddaebc19990b43d5e668e6b077cf5bf12d21be3ef33acf475963";
    environment = {
      PGID = "1000";
      PUID = "1000";
      TZ = "America/New_York";
      CMD_HOST = "0.0.0.0";
      CMD_PORT = "3000";
      CMD_DOMAIN = "hedgedoc.zah.rocks";
      CMD_ALLOW_ANONYMOUS = "false";
      CMD_ALLOW_FREEURL = "true";
      CMD_REQUIRE_FREEURL_AUTHENTICATION = "true";
      CMD_ALLOW_GRAVATAR = "true"; # disables gravatar despite the name
      CMD_EMAIL = "false";
      CMD_ALLOW_EMAIL_REGISTER = "false";
      CMD_USECDN = "false";
      CMD_PROTOCOL_USESSL = "true";
      CMD_URL_ADDPORT = "false";
      CMD_HSTS_ENABLE = "true";
      DEBUG = "true";

      ### keycloak oauth
      CMD_OAUTH2_CLIENT_ID = "hedgedoc";
      CMD_OAUTH2_PROVIDERNAME = "Keycloak";
      CMD_OAUTH2_USER_PROFILE_USERNAME_ATTR = "preferred_username";
      CMD_OAUTH2_USER_PROFILE_DISPLAY_NAME_ATTR = "name";
      CMD_OAUTH2_USER_PROFILE_EMAIL_ATTR = "email";
      CMD_OAUTH2_TOKEN_URL = "https://idp.zah.rocks/realms/falcon/protocol/openid-connect/token";
      CMD_OAUTH2_AUTHORIZATION_URL = "https://idp.zah.rocks/realms/falcon/protocol/openid-connect/auth";
      CMD_OAUTH2_USER_PROFILE_URL = "https://idp.zah.rocks/realms/falcon/protocol/openid-connect/userinfo";
      CMD_OAUTH2_SCOPE = "openid email profile";
    };
    extraOptions = ["--net=external" "--net=internal"];
    environmentFiles = [config.sops.secrets."hedgedoc/env".path];
    dependsOn = ["traefik" "postgres"];
    ports = ["3000"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.hedgedoc.rule" = "Host(`hedgedoc.zah.rocks`)";
      "traefik.http.routers.hedgedoc.entrypoints" = "websecure";
      "traefik.http.routers.hedgedoc.tls.certresolver" = "generic";
    };
  };
}
