{...}: {
  virtualisation.oci-containers.containers.com-andrewzah = {
    autoStart = true;
    image = "docker.io/andrewzah/com-andrewzah:latest@sha256:ccb98918a56a5382694905c8c1f8433ebbc37f3a39af6038999a65b277d1ebb2";
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.com-andrewzah.rule" = "Host(`andrewzah.com`)";
      "traefik.http.routers.com-andrewzah.entrypoints" = "websecure";
      "traefik.http.routers.com-andrewzah.tls.certresolver" = "cloudflare";
    };
    extraOptions = [ "--net=external" ];
    ports = ["2020"];
  };
}
