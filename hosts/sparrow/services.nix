{...}: {
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.openssh.enable = true;

  services.prometheus = {
    enable = true;

    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = ["localhost:9100" "192.168.2.61:9100"];
          }
        ];
      }
    ];
  };

  # exporters.unpoller -> collect UniFi stats
  # exporters.zfs
  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
    enabledCollectors = ["systemd"];
    disabledCollectors = ["textfile"];
    openFirewall = true;
  };

  #services.vaultwarden = {
  #  enable = true;
  #};
}
