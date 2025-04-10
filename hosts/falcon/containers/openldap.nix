{config, ...}: {
  sops.secrets."openldap/env" = {};
  sops.secrets."ldapaccountmanager/env" = {};

  virtualisation.oci-containers.containers.lam = {
    autoStart = false;
    image = "ghcr.io/ldapaccountmanager/lam:9.1@sha256:d40f8d3f106035b366a857e4a027236fc8b9ffcdbef2005a89a104b9c018e55a";
    environment = {
      LAM_LANG = "en_US";
      LAM_SKIP_PRECONFIGURE = "false";
      LDAP_SERVER = "ldap://openldap:1389";
      LDAP_DOMAIN = "zah.rocks";
      LDAP_BASE_DN = "dc=zah,dc=rocks";
      LDAP_USERS_DN = "ou=people,dc=zah,dc=rocks";
      LDAP_GROUPS_DN = "ou=groups,dc=zah,dc=rocks";
      DEBUG = "false";
    };
    extraOptions = ["--net=internal" "--net=external"];
    dependsOn = ["traefik" "openldap"];
    environmentFiles = [config.sops.secrets."ldapaccountmanager/env".path];
    ports = ["80"];
    labels = {
      "traefik.enable" = "true";

      ## tls-challenge
      "traefik.http.routers.ldapaccountmanager.rule" = "Host(`lam.idp.zah.rocks`)";
      "traefik.http.routers.ldapaccountmanager.entrypoints" = "websecure";
      "traefik.http.routers.ldapaccountmanager.tls.certresolver" = "generic";
    };
  };

  virtualisation.oci-containers.containers.openldap = {
    autoStart = true;
    image = "docker.io/bitnami/openldap:2.6.9@sha256:25f12e8abb34bd89b47bc4f726f92f7d3195260c2be16950b38c20dd775d0aef";
    environment = {
      LDAP_ROOT = "dc=zah,dc=rocks";
      LDAP_DOMAIN = "zah.rocks";
      LDAP_TLS = "false";
      LDAP_CONFIG_ADMIN_ENABLED = "true";
    };
    environmentFiles = [config.sops.secrets."openldap/env".path];
    extraOptions = ["--net=internal"];
    ports = ["1389"];
    volumes = [
      # needs to be chowned to 1001:1001
      "/eagle/data/docker/openldap/openldap/:/etc/ldap/slapd.d/:rw"
      "/eagle/data/docker/openldap/runtime/:/var/lib/ldap/:rw"
      "/eagle/data/docker/openldap/data/:/bitnami/openldap/:rw"
    ];
  };
}
