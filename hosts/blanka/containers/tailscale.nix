{config, ...}: {
  sops.secrets."tailscale/env" = {};

  virtualisation.oci-containers.containers.tailscale = {
    autoStart = false;
    image = "";
    ports = [];
    environmentFiles = [config.sops.secrets."tailscale/env".path];
    extraOptions = ["--network="];
    networks = ["external"];
    capabilities = {
      NET_ADMIN = true;
    };
    volumes = [
      "/blanka/tailscale/lib/:/var/lib/"
      "/dev/net/tun:/dev/net/tun"
    ];
    labels = {};
  };
}
