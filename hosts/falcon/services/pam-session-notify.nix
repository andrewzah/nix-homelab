## Pings me whenever someone ssh's in,
## via pushover.net
{pkgs, config, ...}: let
  inherit (pkgs.lib) mkDefault mkAfter;

  pamPath = config.sops.secrets."pushover/pam".path;
  userIdPath = config.sops.secrets."pushover/userid".path;

  script = pkgs.writeShellScriptBin "pam-session-notify" ''
    pamToken=$(cat ${pamPath})
    user_id=$(cat ${userIdPath})
    host_name=$(hostname)

    if [ "$PAM_TYPE" = "open_session" ]; then
      curl -s \
        --form-string "token=$pamToken" \
        --form-string "user=$user_id" \
        --form-string "priority=1" \
        --form-string "message=SSH Login on $host_name: $PAM_USER from $PAM_RHOST" \
        https://api.pushover.net/1/messages.json
    elif [ "$PAM_TYPE" = "close_session" ]; then
      curl -s \
        --form-string "token=$pamToken" \
        --form-string "user=$user_id" \
        --form-string "message=SSH Logout on $host_name: $PAM_USER from $PAM_RHOST" \
        https://api.pushover.net/1/messages.json
    fi
  '';
in {
  sops.secrets."pushover/pam" = {};
  sops.secrets."pushover/userid" = {};

  security.pam.services.sshd.text = mkDefault (
    mkAfter "session optional pam_exec.so ${script}/bin/pam-session-notify"
  );
}
