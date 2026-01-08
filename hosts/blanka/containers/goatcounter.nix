{config, ...}: {
  sops.secrets."goatcounter/env" = {};

  virtualisation.oci-containers.containers.goatcounter = {
    autoStart = true;
    image = "docker.io/andrewzah/goatcounter:2.7.0.1@sha256:07b88a4d9ed2da822f8fa8dac8e582c373db2869f2fe13078e0bd93e71bc96bd";
    ports = ["3443"];
    environment = {
      GC_PORT = "3443";
      GC_LISTEN = "0.0.0.0:3443";
      GC_TLS = "none";
    };
    environmentFiles = [config.sops.secrets."goatcounter/env".path];
    volumes = ["/blanka/goatcounter/:/data/:rw"];
    dependsOn = ["traefik" "postgres"];
    extraOptions = ["--net=internal" "--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.goatcounter-dns.rule" = "Host(`stats.andrewzah.com`)";
      "traefik.http.routers.goatcounter-dns.entrypoints" = "websecure";
      "traefik.http.routers.goatcounter-dns.tls.certresolver" = "cloudflare";

      ## tls-challenge
      #"traefik.http.routers.goatcounter-tls.rule" = "Host(`stats.benzah.com`) || Host(`stats.nixseoul.club`)";
      #"traefik.http.routers.goatcounter-tls.entrypoints" = "websecure";
      #"traefik.http.routers.goatcounter-tls.tls.certresolver" = "generic";
    };
  };
}
