### gtx 980 needs proprietary drivers
{config, ...}: {
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable; # beta | production

  hardware.nvidia.open = false;
  hardware.nvidia.modesetting.enable = true;

  hardware.nvidia-container-toolkit.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

  hardware.graphics.enable32Bit = true;
}
