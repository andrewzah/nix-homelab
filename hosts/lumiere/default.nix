{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./virtualization.nix
    ./nvidia.nix
    ./unfree.nix

    ./containers/docker-socket-proxy.nix

    ./containers/tunarr.nix

    ./containers/arr.nix
    ./containers/atuin.nix
    #./containers/ersatztv.nix
    ./containers/gluetun.nix
    ./containers/grafana.nix
    ./containers/homepage.nix
    ./containers/jellyfin.nix
    ./containers/keycloak.nix
    ./containers/mealie.nix
    ./containers/postgres.nix
    ./containers/prometheus.nix
    ./containers/scrutiny.nix
    ./containers/static-sites.nix
    ./containers/traefik.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

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
    packages = with pkgs; [
      tree
      neovim
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    tmux
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
