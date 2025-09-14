{config, ...}: {
  sops.secrets = {
    "mc-proxy/env" = {};
    "mc-survival/env" = {};
    "mc-creative/env" = {};
  };

  virtualisation.oci-containers.containers.mc-proxy = {
    autoStart = true;
    image = "itzg/mc-proxy:java24@sha256:ad64b67e66caf63e937263993f3ac93dea27f3cce6a10607f8894ea9a64c21eb";
    environment = {
      TYPE = "VELOCITY";
      MEMORY = "512m";
    };
    ports = ["25565:25565" "25955:25955"];
    extraOptions = ["--net=internal"];
    environmentFiles = [config.sops.secrets."mc-proxy/env".path];
    dependsOn = ["traefik"];
    volumes = [
      "/blanka/horangi-minecraft/mc-proxy/config/:/config/:rw"
    ];
  };

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
      MOTD = "Horangi - Survival";
      SERVER_NAME = "Horangi - Survival";
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
      MODS = "/mods";
      LEVEL = "horangi-survival";
      USE_AIKAR_FLAGS = "FALSE";
      MAX_TICK_TIME = "-1";
      ENFORCE_SECURE_PROFILE = "FALSE";
      TZ = "Asia/Seoul";
      EULA = "TRUE";
    };
    ports = ["25565" "25956:25956" "8100:8100"];
    extraOptions = [
      "--net=external"
      "--net=internal"
    ];
    environmentFiles = [config.sops.secrets."mc-survival/env".path];
    dependsOn = ["mc-proxy"];
    volumes = [
      "/blanka/horangi-minecraft/mc-survival/mods/:/mods/:rw"
      "/blanka/horangi-minecraft/mc-survival/data/:/data/:rw"
    ];
  };

  virtualisation.oci-containers.containers.mc-creative = {
    autoStart = true;
    image = "itzg/minecraft-server:java21-graalvm@sha256:cac38d2436520305bbec676723dbabd072d14f1cd6c6e893aa62f77aacd51ff7";
    hostname = "mc-creative";
    environment = {
      VERSION = "1.21.8";
      TYPE = "FABRIC";
      MEMORY = "2G";
      USE_AIKAR_FLAGS = "FALSE";
      MODE = "creative";
      LEVEL = "horangi-creative";
      LEVEL_TYPE = "flat";
      GENERATOR_SETTINGS = ''
        {
                  "layers": [
                      {
                          "block": "minecraft:bedrock",
                          "height": 1
                      },
                      {
                          "block": "minecraft:stone_bricks",
                          "height": 1
                      },
                      {
                          "block": "minecraft:air",
                          "height": 10
                      },
                      {
                          "block": "minecraft:grass",
                          "height": 1
                      },
                      {
                          "block": "minecraft:white_wool",
                          "height": 1
                      }
                  ],
                  "biome": "minecraft:plains"
              }
      '';
      SERVER_NAME = "horangi-creative";
      SPAWN_PROTECTION = "0";
      ONLINE_MODE = "false";
      ENABLE_AUTOPAUSE = "TRUE";
      ENABLE_QUERY = "false";
      ENABLE_ROLLING_LOGS = "true";
      DIFFICULTY = "peaceful";
      PVP = "FALSE";
      TZ = "America/New_York";
      MODRINTH_ALLOWED_VERSION_TYPE = "release";
      ENFORCE_SECURE_PROFILE = "false"; # chat signing off
      WHITELIST_FILE = "/data/whitelist.json";
      ENFORCE_WHITELIST = "true";
      EXISTING_WHITELIST_FILE = "SYNC_FILE_MERGE_LIST";
      OPS_FILE = "/data/ops.json";
      OVERRIDE_OPS = "TRUE";
      EXISTING_OPS_FILE = "SYNC_FILE_MERGE_LIST";
      MODS = "/mods";
      EULA = "TRUE";
    };
    environmentFiles = [config.sops.secrets."mc-creative/env".path];
    dependsOn = ["mc-proxy"];
    ports = ["25565" "25957:25957"];
    extraOptions = ["--net=internal"];
    volumes = [
      "/blanka/horangi-minecraft/mc-creative/mods/:/mods/:rw"
      "/blanka/horangi-minecraft/mc-creative/data/:/data/:rw"
    ];
  };
}
