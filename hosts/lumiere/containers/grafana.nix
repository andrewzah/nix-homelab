{config, ...}: {
  sops.secrets."grafana/env" = {};

  virtualisation.oci-containers.containers.grafana = {
    autoStart = true;
    image = "docker.io/library/grafana:v3.8.1@sha256:2b6f734e372c1b4717008f7d0a0152316aedd4d13ae17ef1e3268dbfaf68041b";
    ports = ["3000"];
    dependsOn = ["postgres" "prometheus"];
    extraOptions = [
      "--net=external"
      "--net=internal"
    ];
    environmentFiles = [config.sops.secrets."grafana/env".path];
    volumes = [
      "/lumiere/data/docker/grafana/data/:/var/lib/grafana/:rw"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.grafana.rule" = "Host(`grafana.lumiere.wtf`)";
      "traefik.http.routers.grafana.entrypoints" = "websecure";
      "traefik.http.routers.grafana.tls.certresolver" = "porkbun";
    };
  };
}
