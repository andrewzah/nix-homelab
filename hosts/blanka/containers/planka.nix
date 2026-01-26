{config, ...}: {
  sops.secrets."planka/env" = {};

  virtualisation.oci-containers.containers.planka = {
    autoStart = true;
    user = "1000:1000";
    image = "ghcr.io/plankanban/planka:2.0.0-rc.4@sha256:1cb538e1a3476126e582e705b32a55adc940306d4ea09cca52dc4342803c11a7";
    ports = ["1337"];
    dependsOn = ["traefik" "postgres"];
    extraOptions = ["--net=external" "--net=internal"];
    environmentFiles = [config.sops.secrets."planka/env".path];
    volumes = [
      "/blanka/planka/public/favicons/:/app/public/favicons/:rw"
      "/blanka/planka/public/user-avatars/:/app/public/user-avatars/:rw"
      "/blanka/planka/public/background-images/:/app/public/background-images/:rw"
      "/blanka/planka/private/attachments/:/app/private/attachments/:rw"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.planka-ui.rule" = "Host(`planka.abare.party`)";
      "traefik.http.routers.planka-ui.entrypoints" = "websecure";
      "traefik.http.routers.planka-ui.tls.certresolver" = "porkbun";

      # websockets
      "traefik.http.routers.planka-wss.rule" = "Host(`planka.abare.party`) && PathPrefix(`/socket.io`)";
      "traefik.http.routers.planka-wss.entrypoints" = "websecure";
      "traefik.http.routers.planka-wss.tls.certresolver" = "porkbun";
    };
  };
}
