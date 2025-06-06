{config,...}: {
  sops.secrets."forgejo/env" = {};

  virtualisation.oci-containers.containers.forgejo = {
    autoStart = false;
    image = "docker.io/linuxserver/hedgedoc:1.10.3@sha256:049cc4dd0e6eddaebc19990b43d5e668e6b077cf5bf12d21be3ef33acf475963";
    environment = {
      "USER_UID" = "1000";
      "USER_GID" = "1000";
    };
    extraOptions = ["--net=external" "--net=internal"];
    environmentFiles = [config.sops.secrets."forgejo/env".path];
    dependsOn = ["traefik" "postgres"];
    ports = ["3000" "2222"];
    volumes = [
      "/eagle/data/docker/forgejo/:/data/:rw"
      "/etc/localtime:/etc/localtime:ro"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.forgejo-web.rule" = "Host(`git.andrewzah.com`)";
      "traefik.http.routers.forgejo-web.entrypoints" = "websecure";
      "traefik.http.routers.forgejo-web.tls.certresolver" = "cloudflare";
      "traefik.http.routers.forgejo-web.service" = "forgejo-web";
      "traefik.http.services.forgejo-web.loadbalancer.server.port" = "3000";
      # ssh
      "traefik.tcp.routers.forgejo-ssh.entrypoints" = "ssh";
      "traefik.tcp.routers.forgejo-ssh.rule" = "HostSNI(`*`)";
      "traefik.tcp.routers.forgejo-ssh.service" = "forgejo-ssh";
      "traefik.tcp.services.forgejo-ssh.loadbalancer.server.port" = "2222";
    };
  };
}
