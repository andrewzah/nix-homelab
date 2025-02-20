{...}: {
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
  };

  services.prometheus.exporters.zfs.enable = true;
}
