{config, ...}: {
  sops.secrets."rabbitmq/env" = {};

  virtualisation.oci-containers.containers.rabbitmq = {
    autoStart = true;
    hostname = "rabbitmq";
    image = "docker.io/library/rabbitmq:4.2-alpine@sha256:f5efafa65aada6282656e2b5e61fca04de994c55559dbc1622dee0f05e3cb928";
    ports = [
      "4369"
      "5672"
      "15672:15672" # management ui
    ];
    environmentFiles = [config.sops.secrets."rabbitmq/env".path];
    environment.TZ = config.time.timeZone;
    extraOptions = ["--net=internal"];
  };
}
