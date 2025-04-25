{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./virtualisation.nix
    ./services.nix

    ./services/pam-session-notify.nix
    ./services/smartd.nix
    ./services/zfs-zed.nix
    #./services/prometheus.nix

    ## containers
    ./containers/baikal.nix
    ./containers/com-andrewzah.nix
    ./containers/goatcounter.nix
    #./containers/mariadb.nix
    ./containers/postgres.nix
    ./containers/redis.nix
    #./containers/servatrice.nix
    ./containers/traefik.nix
    ./containers/vaultwarden.nix
    ./containers/whoami.nix
    ./containers/atuin.nix

    ./containers/hedgedoc.nix
    ./containers/keycloak.nix
    ./containers/openldap.nix
  ];
  nix.settings.experimental-features = ["nix-command" "flakes"];

  sops.defaultSopsFile = ../../secrets.yaml;
  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.generateKey = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.supportedFilesystems = ["zfs" "btrfs"];
  boot.zfs.extraPools = ["eagle"];

  networking.hostName = "falcon";
  networking.hostId = "958299a5";
  time.timeZone = "America/New_York";

  users.users.dragon = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = [];
  };

  environment.systemPackages = (with pkgs; [git vim]);
  system.stateVersion = "24.11";
}
