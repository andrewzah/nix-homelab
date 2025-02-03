{pkgs, ...}: {
  imports = [./hardware-configuration.nix];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";

  networking.hostName = "falcon";
  time.timeZone = "America/New_York";

  users.users.dragon = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [vim];

  services.openssh.enable = true;
  system.stateVersion = "24.11"; # Did you read the comment?
}
