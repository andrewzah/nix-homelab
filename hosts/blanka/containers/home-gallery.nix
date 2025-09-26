{config, ...}: {
  virtualisation.oci-containers.containers.home-gallery = {
    autoStart = false;
    hostname = "home-gallery";
    image = "docker.io/xemle/home-gallery:c2b5674a@sha256:74be27e2f8e631a3f17a3a447d3c18acbaad3beee82e261e44d4c4faeb7cfd3a";
    ports = ["32655:3000" "3000"];
    cmd = ["run server"];
    volumes = [
      "/blanka/home-gallery/data/:/data/:rw"
      "/blanka/backups/iphone-backup_2025-09-26/:/data/iphone-backup_2025-09-26/:rw"
    ];
    #environmentFiles = [config.sops.secrets."home-gallery/env".path];
    #dependsOn = ["traefik" "postgres"];
    #extraOptions = ["--net=internal"];
    #labels = {};
  };
}
