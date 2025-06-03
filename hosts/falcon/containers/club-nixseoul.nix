{...}: {
  virtualisation.oci-containers.containers.club-nixseoul = {
    autoStart = true;
    image = "docker.io/andrewzah/club-nixseoul:latest@sha256:3a8304da97153cb56543072a2f28f6c5ba8e5ac1316425e97753890dc791000f";
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.club-nixseoul.rule" = "Host(`nixseoul.club`)";
      "traefik.http.routers.club-nixseoul.entrypoints" = "websecure";
      "traefik.http.routers.club-nixseoul.tls.certresolver" = "cloudflare";
    };
    extraOptions = ["--net=external"];
    ports = ["2020"];
  };
}
