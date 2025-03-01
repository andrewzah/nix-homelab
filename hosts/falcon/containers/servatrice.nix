{config,...}: {
  sops.secrets."servatrice/ini" = {};

  virtualisation.oci-containers.containers.servatrice = {
    autoStart = true;
    image = "docker.io/andrewzah/servatrice:latest";
    ports = [
      "4747:4747" # tcp
      "4748:4748" # websocket
    ];
    dependsOn = ["traefik" "mariadb"];
    entrypoint = "servatrice";
    cmd = [
      "--config"
      "/home/servatrice/servatrice.ini"
      "--log-to-console"
    ];
    extraOptions = [
      "--net=internal"
      "--net=external"

      #"--health-cmd"
      #"curl -f http://localhost:4747"
      #"--health-interval=5s"
      #"--health-timeout=10s"
      #"--health-retries=5"
      #"--health-start-period=1s"
    ];
    volumes = [
      "${config.sops.secrets."servatrice/ini".path}:/home/servatrice/servatrice.ini:ro"
    ];
    labels = {
      #"traefik.enable" = "true";
      #"traefik.tcp.routers.servatrice.rule" = "HostSNI(`*`)";
      #"traefik.tcp.routers.servatrice.entrypoints" = "servatrice";
      ##"traefik.tcp.routers.servatrice.tls" = "true";
      ##"traefik.tcp.routers.servatrice.tls.certresolver" = "generic";
      #"traefik.tcp.routers.servatrice.service" = "servatrice";
      #"traefik.tcp.services.servatrice.loadbalancer.server.port" = "4747";
    };
  };
}

      # websockets
      #"traefik.http.routers.servatrice-wss.rule" = "Host(`servatrice.zah.rocks`) && Path(`/servatrice`)";
      #"traefik.http.routers.servatrice-wss.entrypoints" = "servatrice-wss";
      #"traefik.http.routers.servatrice-wss.service" = "servatrice-wss";
      #"traefik.http.services.servatrice-wss.loadbalancer.server.port" = "4748";
