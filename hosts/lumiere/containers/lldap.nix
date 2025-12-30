{config, ...}: {
  sops.secrets."lldap/env" = {};

  virtualisation.oci-containers.containers.lldap = {
    autoStart = true;
    image = "docker.io/lldap/lldap:2025-12-24@sha256:39190e688c130207380bf0789f1b09dd1786c1bac8c08ac9ca880ed8e34c4499";
    ports = [
      "3890" # ldap API, DON'T EXPOSE
      "17170:17170" # web UI
    ];
    environment = {
      TZ = config.time.timeZone;
      UID = "1000";
      GID = "1000";
    };
    environmentFiles = [config.sops.secrets."lldap/env".path];
    volumes = ["/lumiere/data/docker/lldap/data/:/data/:rw"];
    extraOptions = ["--net=idp"];
  };
}
