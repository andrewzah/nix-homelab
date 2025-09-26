{config, ...}: {
  virtualisation.oci-containers.containers.home-gallery-api = {
    autoStart = false;
    hostname = "home-gallery-api";
    image = "xemle/home-gallery-api-server:cbe96adc@sha256:cbf989ff61e0ea4f6654b85fc040938caa8e2f7798d176faedd14f9800495ad2";
    environment = {
      BACKEND = "node";
    };
    ports = ["3000"];
    extraOptions = ["--net=home-gallery"];
  };

  virtualisation.oci-containers.containers.home-gallery = {
    autoStart = false;
    hostname = "home-gallery";
    image = "docker.io/xemle/home-gallery:c2b5674a@sha256:74be27e2f8e631a3f17a3a447d3c18acbaad3beee82e261e44d4c4faeb7cfd3a";
    environment = {
      GALLERY_API_SERVER = "http://home-gallery-api:3000";
      GALLERY_API_SERVER_CONCURRENT = 5;
      GALLERY_API_SERVER_TIMEOUT = 30;
    };
    ports = ["32655:3000" "3000"];
    cmd = ["run" "server"];
    volumes = [
      "/blanka/home-gallery/data/:/data/:rw"
      "/blanka/backups/iphone-backup_2025-09-26/:/data/iphone-backup_2025-09-26/:rw"
    ];
    extraOptions = ["--net=home-gallery"];
  };
}
