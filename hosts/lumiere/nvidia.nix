{config, ...}: {
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable; # beta | production
  hardware.nvidia.open = true;

  hardware.nvidia-container-toolkit.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

  hardware.graphics.enable32Bit = true;
}
