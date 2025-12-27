{...}: {
  services.openssh.enable = true;
  services.tailscale.enable = true;

  services.prometheus.exporters.node = {
    enable = true;
    port = 9000;

    enabledCollectors = [
      "cpu"
      "diskstats"
      "ethtool"
      "meminfo"
      "processes"
      "tcpstat"
      "time"
      "zfs"
    ];
  };
}
