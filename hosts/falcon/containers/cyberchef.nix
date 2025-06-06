{...}: {
  virtualisation.oci-containers.containers.cyberchef = {
    autoStart = true;
    image = "ghcr.io/gchq/cyberchef:10.19.4@sha256:a2bfe382b2547bdd0a3d0523b9a6b85fab833c56bcec86d600ba6266910b533e";
    ports = ["8000"];
    dependsOn = ["traefik"];
    extraOptions = ["--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.cyberchef.rule" = "Host(`chef.zah.rocks`)";
      "traefik.http.routers.cyberchef.entrypoints" = "websecure";
      "traefik.http.routers.cyberchef.tls.certresolver" = "generic";
    };
  };
}
