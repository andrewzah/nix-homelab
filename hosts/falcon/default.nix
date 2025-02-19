{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./virtualisation.nix

    ./services/traefik.nix
    ./services/postgres.nix
    ./services/whoami.nix
  ];
  nix.settings.experimental-features = ["nix-command" "flakes"];

  sops.defaultSopsFile = ../../secrets.yaml;
  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.generateKey = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.supportedFilesystems = ["zfs" "btrfs"];
  boot.zfs.extraPools = [ "eagle" ];

  networking.hostName = "falcon";
  networking.hostId = "958299a5";
  time.timeZone = "America/New_York";

  users.users.dragon = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = [];
  };

  environment.systemPackages = (with pkgs; [vim]);
  services.openssh.enable = true;
  system.stateVersion = "24.11";
}
