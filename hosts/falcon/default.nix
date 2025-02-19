{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix

    ./virtualisation.nix
  ];

  sops.defaultSopsFile = ../../secrets.yaml;
  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.generateKey = true;
  sops.secrets.example-key = {};

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";

  networking.hostName = "falcon";
  time.timeZone = "America/New_York";

  users.users.dragon = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = (with pkgs; []);
  };

  environment.systemPackages = (with pkgs; [vim]);
  services.openssh.enable = true;
  system.stateVersion = "24.11";
}
