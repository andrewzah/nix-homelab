{...}: {
  virtualisation.oci-containers.containers.club-nixseoul = {
    autoStart = true;
    image = "docker.io/andrewzah/club-nixseoul:latest@sha256:31428f578bc42efeebcecf8190c8080a7d1f9fcd16d657b61e36db3de2a609d1";
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
