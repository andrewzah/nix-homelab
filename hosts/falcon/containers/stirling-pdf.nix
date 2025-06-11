{config, ...}: {
  sops.secrets."stirling-pdf/env" = {};

  virtualisation.oci-containers.containers.stirling-pdf = {
    # don't enable until we set up oauth proxying
    # i REALLY don't want upload forms exposed publicly
    autoStart = false;
    image = "docker.io/stirlingtools/stirling-pdf:latest@sha256:396ca949b81198a65b9abfec38518fa44e871b1970dad9f9718ffd030eef9b92";
    environment = {
      LANGS = "en_US";
    };
    ports = ["8080"];
    environmentFiles = [config.sops.secrets."stirling-pdf/env".path];
    dependsOn = ["traefik"];
    extraOptions = [
      "--net=external"
      "--network-alias=stirling-pdf.zah.rocks"
    ];
    volumes = [
      "/eagle/data/docker/stirling-pdf/trainingData/:/usr/share/tessdata/:rw"
      "/eagle/data/docker/stirling-pdf/extraConfigs/:/configs/:rw"
      "/eagle/data/docker/stirling-pdf/customFiles/:/customFiles/:rw"
      "/eagle/data/docker/stirling-pdf/logs/:/logs/:rw"
      "/eagle/data/docker/stirling-pdf/pipeline/:/pipeline/:rw"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.stirling-pdf.rule" = "Host(`stirling-pdf.zah.rocks`)";
      "traefik.http.routers.stirling-pdf.entrypoints" = "websecure";
      "traefik.http.routers.stirling-pdf.tls.certresolver" = "generic";
    };
  };
}
