{...}: {
  services.openssh.enable = true;

  services.jellyfin = {
    enable = true;
    dataDir = "/lumiere/media/jellyfin";
  };
}
