{config, ...}: {
  sops.secrets."docmost/env" = {};
  virtualisation.oci-containers.containers.docmost = {
    autoStart = true;
    image = "docker.io/docmost/docmost:0.24.1@sha256:ae9a964d58fe45071b2d87afe44ec1b0fb74a6e0124e831e906fce96b0258a84";
    ports = ["3000"];
    environment.TZ = config.time.timeZone;
    environmentFiles = [config.sops.secrets."docmost/env".path];
    volumes = ["/lumiere/data/docker/docmost/data/:/app/data/storage/:rw"];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external" "--net=internal"];
    labels = {
      "traefik.enable" = "true";

      # regular https
      "traefik.http.routers.docmost.rule" = "Host(`docmost.lumiere.wtf`)";
      "traefik.http.routers.docmost.entrypoints" = "websecure";
      "traefik.http.routers.docmost.tls.certresolver" = "porkbun";

      # websockets
      "traefik.http.routers.docmost-wss.rule" = "Host(`docmost.lumiere.wtf`) && (PathPrefix(`/collab`) || PathPrefix(`/socket.io`))";
      "traefik.http.routers.docmost-wss.entrypoints" = "websecure";
      "traefik.http.routers.docmost-wss.tls.certresolver" = "porkbun";
    };
  };
}
