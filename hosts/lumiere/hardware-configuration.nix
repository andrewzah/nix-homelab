{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    kernelModules = ["i915" "kvm-amd"];
    extraModulePackages = [];

    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usb_storage"
      "usbhid"
      "sd_mod"
      "igb"
    ];
    initrd.kernelModules = [];
    initrd.network = {
      enable = true;
      ssh = {
        enable = true;
        port = 2222;
        hostKeys = [
          /etc/ssh/ssh_host_ed25519_key
        ];
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGuChILFlgTqJiiNFcy7GunS13VlVvnOhypgwVtnhL0X Andrew Zah <zah@andrewzah.com> (ltddr)"
        ];
      };
    };

    zfs.extraPools = ["zpool"];
    zfs.devNodes = "/dev/disk/by-id";
  };

  # note: snapshots
  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };
  # note: services.nfs.server.enable = true; # share zfs over NFS automatically
  # zfs set sharenfs="ro=192.168.1.0/24,all_squash,anonuid=70,anongid=70" zpool/mydata

  fileSystems."/" = {
    device = "zpool/root";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/nix" = {
    device = "zpool/nix";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/var" = {
    device = "zpool/var";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/home" = {
    device = "zpool/home";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/lumiere/media" = {
    device = "zpool/media";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/lumiere/data" = {
    device = "zpool/data";
    fsType = "zfs";
    options = ["zfsutil"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/12CE-A600";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/e3d60c47-be5d-403e-bcf4-fd0c8ff31400";
      randomEncryption = true;
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
