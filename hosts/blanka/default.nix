{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./virtualisation.nix

    ./containers/traefik-forward-auth.nix
    ./containers/traefik.nix

    ./containers/attic.nix
    ./containers/baikal.nix
    ./containers/beaverhabits.nix
    ./containers/goatcounter.nix
    ./containers/healthchecks.nix
    ./containers/linkding.nix
    ./containers/matrix-conduit.nix
    ./containers/mc-horangi.nix
    ./containers/miniflux.nix
    ./containers/postgres.nix
    ./containers/static-sites.nix
    ./containers/tailscale.nix
    ./containers/vaultwarden.nix
    ./containers/whoami.nix
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

  networking.hostName = config.hostname;
  networking.hostId = "5e7b30ea";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Seoul";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users."${config.username}" = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker"];
    packages = [];
  };

  environment.systemPackages = [
    pkgs.git
    pkgs.tmux
    pkgs.vim
  ];

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [22 80 443];
  networking.firewall.allowedUDPPorts = [22 80 443];

  system.stateVersion = "25.05"; # Did you read the comment?
}
