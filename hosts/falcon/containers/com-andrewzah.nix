{...}: {
  virtualisation.oci-containers.containers.com-andrewzah = {
    autoStart = true;
    #image = "docker.io/andrewzah/com-andrewzah:latest@sha256:ac3308f84e4c429412fce732e55d43123b326d8a7beebc60be041f44df40e754";
    image = "docker.io/andrewzah/com-andrewzah:latest@sha256:ac3308f84e4c429412fce732e55d43123b326d8a7beebc60be041f44df40e754";
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.com-andrewzah.rule" = "Host(`andrewzah.com`)";
      "traefik.http.routers.com-andrewzah.entrypoints" = "websecure";
      "traefik.http.routers.com-andrewzah.tls.certresolver" = "cloudflare";
    };
    extraOptions = ["--net=external"];
    ports = ["2020"];
  };
}
