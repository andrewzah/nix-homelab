{...}: {
  virtualisation.oci-containers.containers.org-scfgc = {
    autoStart = true;
    image = "docker.io/andrewzah/org-scfgc:latest@sha256:a36ddaadd8181d70df608f2676efe835026d7c01ac3dad073ed50d4e1977ebe9";
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
