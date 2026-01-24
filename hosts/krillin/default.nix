{
  pkgs,
  lib,
  hostConfig,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./networking.nix
  ];

  system.stateVersion = "25.11";

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = lib.mkForce "weekly"; # Override common module's schedule
      options = lib.mkForce "--delete-older-than 7d"; # Override common module's 30d
    };
    optimise.automatic = true;
  };

  time.timeZone = "America/New_York";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb.layout = "us";

  users.users."${hostConfig.username}" = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  environment.systemPackages = with pkgs; [
    btop
    dig
    git
    inetutils
    nano
    neovim
    tmux
  ];

  documentation.enable = false;
  documentation.nixos.enable = false;
  documentation.man.enable = false;
  documentation.info.enable = false;
  documentation.doc.enable = false;
}
