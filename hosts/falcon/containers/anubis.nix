{...}: {
  virtualisation.oci-containers.containers.anubis = {
    autoStart = false;
    image = "ghcr.io/techarohq/anubis:main@sha256:82269e4d7bc03fb0e2d14fc7e796a9b381b97292b228e5d1dff251915cdf64a5 ";
    environment = {
      BIND = "0.0.0.0:8080";
      TARGET = "http://traefik:3923";
    };
    ports = ["8080"];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.anubis.priority" = "1";
      "traefik.http.routers.anubis.rule" = "PathRegexp(`.*`)";
      "traefik.http.routers.anubis.entrypoints" = "websecure";
    };
  };
}
