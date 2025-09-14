{config, ...}: {
  # todo: sops secrets setup
  virtualisation.oci-containers.containers.mc-survival = {
    autoStart = true;
    image = "itzg/minecraft-server:java21-graalvm@sha256:cac38d2436520305bbec676723dbabd072d14f1cd6c6e893aa62f77aacd51ff7";
    hostname = "mc-survival";
    environment = {
      VERSION = "1.21.8";
      TYPE = "FABRIC";
      MEMORY = "8G";
      ONLINE_MODE = "false";
      ENABLE_AUTOPAUSE = "TRUE";
      ENABLE_QUERY = "false";
      ENABLE_ROLLING_LOGS = "true";
      DIFFICULTY = "hard";
      PVP = "FALSE";
      MODE = "survival";
      SEED = "2900036685049891688";
      ENFORCE_WHITELIST = "true";
      EXISTING_WHITELIST_FILE = "SYNC_FILE_MERGE_LIST";
      OPS_FILE = "/data/ops.json";
      EXISTING_OPS_FILE = "SYNC_FILE_MERGE_LIST";
      WHITELIST_FILE = "/data/whitelist.json";
      OVERRIDE_OPS = "TRUE";
      MODRINTH_ALLOWED_VERSION_TYPE = "release";
      #DATAPACKS = "/datapacks";
      SERVER_NAME = "Horangi";
      MODS = "/mods";
      LEVEL = "horangi-survival";
      USE_AIKAR_FLAGS = "FALSE";
      MAX_TICK_TIME = "-1";
      ENFORCE_SECURE_PROFILE = "FALSE";
      TZ = "Asia/Seoul";
      EULA = "TRUE";
    };
    ports = ["25565" "8100"];
    extraOptions = [
      "--net=external"
      "--net=internal"
    ];
    volumes = [
      "/blanka/horangi-minecraft/mc-survival/mods/:/mods/:rw"
      "/blanka/horangi-minecraft/mc-survival/data/:/data/:rw"
    ];
  };
}
