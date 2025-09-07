{config, ...}: {
  virtualisation.oci-containers.containers.mc-proxy = {
    autoStart = true;
    image = "itzg/mc-proxy:java24@sha256:ad64b67e66caf63e937263993f3ac93dea27f3cce6a10607f8894ea9a64c21eb";
    environment = {
      TYPE = "VELOCITY";
      MEMORY = "512m";
    };
    ports = ["25565:25565"];
    volumes = [
      "/blanka/horangi-minecraft/mc-proxy/config/:/config/:rw"
    ];
  };
}
