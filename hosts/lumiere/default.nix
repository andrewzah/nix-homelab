{pkgs, ...}: {
  imports = [
    ## system configs
    ./hardware-configuration.nix
    ./services.nix
    ./virtualization.nix
    ./nvidia.nix
    ./unfree.nix

    ## Security / OIDC containers
    ./containers/lldap.nix # user source-of-truth
    ./containers/keycloak.nix # OIDC
    ./containers/traefik.nix # routing

    ## misc containers
    ./containers/arr.nix
    ./containers/atuin.nix
    ./containers/docker-socket-proxy.nix
    ./containers/docmost.nix
    ./containers/ersatztv.nix
    ./containers/gluetun.nix
    ./containers/grafana.nix
    ./containers/healthchecks.nix
    ./containers/homepage.nix
    ./containers/jellyfin.nix
    ./containers/mealie.nix
    ./containers/netdata.nix
    ./containers/postgres.nix
    ./containers/prometheus.nix
    ./containers/redis.nix
    ./containers/scrutiny.nix
    ./containers/static-sites.nix
    ./containers/syncthing.nix
    ./containers/uptimekuma.nix
    ./containers/windmill.nix
    ./containers/ytdl-sub.nix
  ];

  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 14d";
    };
  };

  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.generateKey = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostId = "f36e38e3";
    hostName = "lumiere";
    networkmanager.enable = true;
  };
  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb.layout = "us";

  users.users."zah" = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker"];
    packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [
    btop
    dig
    git
    inetutils
    neovim
    tmux
    tree
    vim
  ];

  networking.firewall.allowedTCPPorts = [
    22
    2222
    9000
    51820
  ];
  networking.firewall.allowedUDPPorts = [
    22
    2222
    9000
    51820
  ];

  system.stateVersion = "25.11";
}
