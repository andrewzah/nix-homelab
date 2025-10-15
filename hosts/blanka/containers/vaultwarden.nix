{config, ...}: {
  sops.secrets."vaultwarden/env" = {};

  virtualisation.oci-containers.containers.vaultwarden = {
    autoStart = false;
    image = "docker.io/vaultwarden/server:sha256-3afff94efefc5a4bb89af2fb86f3ac27dff197089e8749ef3c903ed781debd78@sha256:fa5a37f290bc735dfbfe56be09f4ec5f47eb4f5cfbe3b4cb62753af6bee945bd";
    ports = ["4080" "3012"];
    environment = {
      DOMAIN = "http://blanka:4080";
      WEBSOCKET_ENABLED = "true";
      SIGNUPS_ALLOWED = "true";
    };
    environmentFiles = [config.sops.secrets."vaultwarden/env".path];
    volumes = ["/blanka/vaultwarden/:/data/:rw"];
    dependsOn = ["postgres"];
    extraOptions = [
      "--net=internal"

      "--health-cmd"
      "curl -f http://localhost:80"
      "--health-interval=5s"
      "--health-timeout=10s"
      "--health-retries=5"
      "--health-start-period=5s"
    ];
  };
}
