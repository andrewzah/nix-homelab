{config,...}: {
  sops.secrets."forgejo/env" = {};

  virtualisation.oci-containers.containers.forgejo = {
    autoStart = false;
    image = "docker.io/linuxserver/hedgedoc:1.10.3@sha256:049cc4dd0e6eddaebc19990b43d5e668e6b077cf5bf12d21be3ef33acf475963";
    environment = {
      "APP_NAME" = "Zah Forgejo";
      "FORGEJO__CORS__ENABLED" = "true";
      "FORGEJO__SERVER__SSH_DOMAIN" = "git.zah.rocks";
      "RUN_MODE" = "prod";
      "USER_UID" = "1000";
      "USER_GID" = "1000";
    };
    extraOptions = ["--net=external" "--net=internal"];
    environmentFiles = [config.sops.secrets."forgejo/env".path];
    dependsOn = ["traefik" "postgres"];
    ports = ["3000" "22"];
    volumes = [
      "/eagle/data/docker/forgejo/:/data/:rw"
      "/etc/localtime:/etc/localtime:ro"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.git.rule" = "Host(`git.zah.rocks`)";
      "traefik.http.routers.git.entrypoints" = "websecure";
      "traefik.http.routers.git.tls.certresolver" = "generic";
    };
  };
}
