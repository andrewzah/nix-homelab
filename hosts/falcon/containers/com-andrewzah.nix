{...}: {
  virtualisation.oci-containers.containers.com-andrewzah = {
    autoStart = true;
    image = "docker.io/andrewzah/com-andrewzah:latest@sha256:afa11d7cc30a6cf8a7133d33b1817d6fa0e6b277997409f0fd59744b1bf53dda";
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
