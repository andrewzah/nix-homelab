{config,...}: {
  sops.secrets."forgejo/env" = {};

  virtualisation.oci-containers.containers.forgejo = {
    autoStart = false;
    image = "codeberg.org/forgejo/forgejo:11@sha256:d0e930ee26d71e27582200a365d1014faa6da95250c494c002afa87db51575f1";
    environment = {
      "USER_UID" = "1000";
      "USER_GID" = "1000";
    };
    environmentFiles = [config.sops.secrets."forgejo/env".path];
    extraOptions = [
      "--net=external"
      "--net=internal"
      "--network-alias=git.andrewzah.com"
    ];
    dependsOn = ["traefik" "postgres"];
    ports = ["3000" "2222"];
    volumes = [
      "/eagle/data/docker/forgejo/:/data/:rw"
      "/etc/localtime:/etc/localtime:ro"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.forgejo-web.rule" = "Host(`git.andrewzah.com`)";
      "traefik.http.routers.forgejo-web.entrypoints" = "anubis";
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
