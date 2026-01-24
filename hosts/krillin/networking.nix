{
  config,
  pkgs,
  ...
}: let
  WAN = "enp1s0";
  LAN = "enp2s0";
in {
  # see: https://github.com/mdlayher/homelab/blob/main/nixos/routnerr-3/configuration.nix
  # todo: https://github.com/arsfeld/nixos/tree/master/packages/network-metrics-exporter
  # todo: https://github.com/0xERR0R/blocky

  environment.systemPackages = [
    pkgs.bind
  ];

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;

    # By default, do not automatically configure any IPv6 addresses.
    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv6.conf.all.autoconf" = 0;
    "net.ipv6.conf.all.use_tempaddr" = 0;

    # On wired WANs, allow IPv6 autoconfiguration and tempory address use.
    "net.ipv6.conf.wan0.accept_ra" = 2;
    "net.ipv6.conf.wan0.autoconf" = 1;
    "net.ipv6.conf.wan1.accept_ra" = 2;
    "net.ipv6.conf.wan1.autoconf" = 1;
  };

  networking = {
    hostName = "krillin-router";
    networkmanager.enable = false;
    useDHCP = false;

    interfaces."${WAN}".useDHCP = true;
    interfaces."${LAN}" = {
      ipv4.addresses = [
        {
          address = "192.168.1.1";
          prefixLength = 24;
        }
      ];
    };

    nat = {
      enable = true;
      externalInterface = "${WAN}";
      internalInterfaces = ["${LAN}"];
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [22 9100];
      allowedUDPPorts = [22 9100];
    };
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      dhcp-range = ["192.168.1.15,192.168.1.250,12h"];
      interface = "${LAN}";
      server = ["1.1.1.1" "1.0.0.1"];
      no-hosts = true;
      dhcp-option = [
        "option:router,192.168.1.1"
        "option:dns-server,192.168.1.1"
      ];
    };
  };

  services.avahi = {
    enable = true;
    #allowInterfaces = ;
  };
}
