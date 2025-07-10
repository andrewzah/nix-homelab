{...}: {
  virtualisation.oci-containers.containers.org-scfgc = {
    autoStart = true;
    image = "docker.io/andrewzah/org-scfgc:latest@sha256:e7a6a3b1b03151c602697a205f9fcc8eaa4cdd6853ce06236cc9e3b8bdcae127";
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.org-scfgc.rule" = "Host(`scfgc.org`)";
      "traefik.http.routers.org-scfgc.entrypoints" = "websecure";
      "traefik.http.routers.org-scfgc.tls.certresolver" = "generic";
    };
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    ports = ["2020"];
  };
}
