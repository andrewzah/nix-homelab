{...}: {
  virtualisation.oci-containers.containers.club-nixseoul = {
    autoStart = true;
    image = "docker.io/andrewzah/club-nixseoul:latest@sha256:7c0409eff33defc742f7eb83cd801e4243b0ae046b49f3e9326f3f295491f160";
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
