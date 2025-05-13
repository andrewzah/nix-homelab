{...}: {
  virtualisation.oci-containers.containers.org-scfgc = {
    autoStart = true;
    image = "docker.io/andrewzah/scfgc-org:latest@sha256:83f5314e2f3e864c22c94f62de6b09ebea8763e9dd5e0414485d9aa6a5bb0158";
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
