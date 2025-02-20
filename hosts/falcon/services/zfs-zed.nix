{config, ...}: {
  services.zfs.zed = {
    enableMail = false;
    settings = {
      ZED_PUSHOVER_TOKEN = "$(cat ${config.sops.secrets."pushover/pam".path})";
      ZED_PUSHOVER_USER = "$(cat ${config.sops.secrets."pushover/userid".path})";
    };
  };
}
