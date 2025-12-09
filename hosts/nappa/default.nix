{pkgs, ...}: {
  imports = [
    ./services.nix
    ./virtualization.nix

    ./hardware-configuration.nix
  ];
  nix.settings.experimental-features = ["nix-command" "flakes"];

  time.timeZone = "America/New_York";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb.layout = "us";

  users.users.bebop = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker"];
    packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    tmux
  ];

  networking = {
    firewall.enable = true;
    hostName = "nappa";
    firewall.allowedTCPPorts = [22];
    firewall.allowedUDPPorts = [22];
    networkmanager.enable = true;
  };

  system.stateVersion = "25.11";
}
