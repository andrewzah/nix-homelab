{config, ...}: {
  sops.secrets."grafana/env" = {};

  virtualisation.oci-containers.containers.grafana = {
    autoStart = true;
    image = "docker.io/grafana/grafana:12.4.0-20447603318@sha256:890e279baf676d2314832c24d86b32035fb22656b6e6b6d7f3eca1c826abbcb4";
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
