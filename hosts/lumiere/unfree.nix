{lib, ...}: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia"
      "nvidia-persistenced"
      "nvidia-settings"
      "nvidia-x11"
    ];
}
