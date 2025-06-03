{...}: {
  virtualisation.oci-containers.containers.club-nixseoul = {
    autoStart = true;
    image = "docker.io/andrewzah/club-nixseoul:latest@sha256:6ba7a5ccf6f4f4aa22a5fb8130069e64ec1763820b4dc76902ae3a028a772d43";
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.club-nixseoul.rule" = "Host(`nixseoul.club`)";
      "traefik.http.routers.club-nixseoul.entrypoints" = "websecure";
      "traefik.http.routers.club-nixseoul.tls.certresolver" = "generic";
    };
    extraOptions = ["--net=external"];
    ports = ["2020"];
  };
}
