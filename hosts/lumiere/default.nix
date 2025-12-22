{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./virtualization.nix
    ./nvidia.nix
    ./unfree.nix

    ./containers/traefik.nix
    ./containers/jellyfin.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

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
    extraGroups = ["wheel"];
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

  networking.firewall.allowedTCPPorts = [22 2222];
  networking.firewall.allowedUDPPorts = [22 2222];

  system.stateVersion = "25.11";
}
