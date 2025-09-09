{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./virtualisation.nix

    ./containers/mc-proxy.nix
    ./containers/mc-survival.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "blanka";
  networking.hostId = "5e7b30ea";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Seoul";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users."dragon" = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker"];
    packages = [];
  };

  environment.systemPackages = [
    pkgs.vim
    pkgs.git
    pkgs.tmux
  ];

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [22];
  networking.firewall.allowedUDPPorts = [22];

  system.stateVersion = "25.05"; # Did you read the comment?
}
