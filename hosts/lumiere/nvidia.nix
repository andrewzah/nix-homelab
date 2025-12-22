{config, ...}: {
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable; # beta | production
  hardware.nvidia.open = false; # gtx 980 needs proprietary drivers
  hardware.nvidia.modesetting.enable = true; # gtx 980 needs proprietary drivers

  hardware.nvidia-container-toolkit.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

  hardware.graphics.enable32Bit = true;
}
