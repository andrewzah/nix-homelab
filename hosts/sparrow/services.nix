{
  config,
  pkgs,
  ...
}: {
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.openssh.enable = true;

  #services.vaultwarden = {
  #  enable = true;
  #};
}
