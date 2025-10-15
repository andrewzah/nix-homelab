{config, ...}: {
  sops.secrets."vaultwarden/env" = {};

  virtualisation.oci-containers.containers.vaultwarden = {
    autoStart = true;
    image = "docker.io/vaultwarden/server:1.34.3@sha256:84fd8a47f58d79a1ad824c27be0a9492750c0fa5216b35c749863093bfa3c3d7";
    ports = ["4080:80" "3012:3012"];
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
