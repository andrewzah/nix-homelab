{config, ...}: {
  #sops.secrets."ytdl-sub/env" = {};

  virtualisation.oci-containers.containers.ytdl-sub = {
    autoStart = true;
    image = "ghcr.io/jmbannon/ytdl-sub:ubuntu-2025.12.30@sha256:810fe92f46a99deda8e6b1e6cda669d2c502026ec9ce33c751a0b127f7e4459c";
    environment = {
      TZ = config.time.timeZone;
      CRON_SCHEDULE = "0 */6 * * *";
      UPDATE_YT_DLP_ON_START = "true";
      PUID = "1000";
      PGID = "1000";
      NVIDIA_DRIVER_CAPABILITIES = "all";
      NVIDIA_VISIBLE_DEVICES = "all";
    };
    #environmentFiles = [config.sops.secrets."ytdl-sub/env".path];
    volumes = [
      "/lumiere/data/docker/ytdl-sub/config/:/config/:rw"
      "/lumiere/media/youtube/music/:/mnt/lumiere/media/youtube/music/:rw"
      "/lumiere/media/youtube/music_videos/:/mnt/lumiere/media/youtube/music_videos/:rw"
    ];
    devices = ["nvidia.com/gpu=all"];
    extraOptions = ["--net=media"];
  };
}
