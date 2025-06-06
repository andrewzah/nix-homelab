{...}: {
  virtualisation.oci-containers.containers.club-nixseoul = {
    autoStart = true;
    image = "docker.io/andrewzah/club-nixseoul:latest@sha256:4d33ba90ef795a0a3f10ec64a61805393377a1de488a55e81aed895f834d0cfd";
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
