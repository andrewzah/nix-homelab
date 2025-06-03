{config, ...}: {
  sops.secrets."goatcounter/env" = {};

  virtualisation.oci-containers.containers.goatcounter = {
    autoStart = true;
    image = "docker.io/andrewzah/goatcounter:c059188a3@sha256:02b13bc81d509fe049bd9765cbd73f7dd3cc663a4ddfc6b03fa6865c6c3c5423";
    ports = ["3443"];
    environment = {
      GC_PORT = "3443";
      GC_LISTEN = "0.0.0.0:3443";
      GC_TLS = "none";
    };
    environmentFiles = [config.sops.secrets."goatcounter/env".path];
    volumes = ["/eagle/data/docker/goatcounter/:/data/:rw"];
    dependsOn = ["traefik" "postgres"];
    extraOptions = ["--net=internal" "--net=external"];
    labels = {
      "traefik.enable" = "true";

      ## dns-challenge
      "traefik.http.routers.goatcounter-dns.rule" = "Host(`stats.andrewzah.com`) || Host(`stats.worldwarrior.online`)";
      "traefik.http.routers.goatcounter-dns.entrypoints" = "websecure";
      "traefik.http.routers.goatcounter-dns.tls.certresolver" = "cloudflare";

      ## tls-challenge
      "traefik.http.routers.goatcounter-tls.rule" = "Host(`stats.benzah.com`) || Host(`stats.homegrownbinaries.com`) || Host(`stats.nixclub.seoul`)";
      "traefik.http.routers.goatcounter-tls.entrypoints" = "websecure";
      "traefik.http.routers.goatcounter-tls.tls.certresolver" = "generic";
    };
  };
}
