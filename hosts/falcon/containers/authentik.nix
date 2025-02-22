{config, ...}: {
  sops.secrets."authentik/env" = {};

  #virtualisation.oci-containers.containers.authentik = {
  #  autoStart = true;
  #  hostname = "authentik";
  #  image = "ghcr.io/goauthentik/server:2024.12.3@sha256:b0c0552385922ee8732194e0fbe8d95fd9099880dc169ff7d1b36db4af52cbd8";
  #  cmd = ["server"];
  #  dependsOn = ["postgres" "redis"];
  #  ports = ["9000" "9443"];
  #  extraOptions = ["--net=internal" "--net=external"];
  #  volumes = [
  #    "/eagle/data/docker/authentik/custom-templates/:/templates/:rw"
  #    "/eagle/data/docker/authentik/media/:/media/:rw"
  #  ];
  #};

  #virtualisation.oci-containers.containers.authentik-worker = {
  #  autoStart = true;
  #  image = "ghcr.io/goauthentik/server:2024.12.3@sha256:b0c0552385922ee8732194e0fbe8d95fd9099880dc169ff7d1b36db4af52cbd8";
  #  cmd = ["worker"];
  #  dependsOn = ["postgres" "redis"];
  #  extraOptions = ["--net=internal" "--net=external"];
  #  volumes = [
  #    "/eagle/data/docker/authentik/custom-templates/:/templates/:rw"
  #    "/eagle/data/docker/authentik/certs/:/certs/:rw"
  #    "/eagle/data/docker/authentik/media/:/media/:rw"
  #  ];
  #};

  #virtualisation.oci-containers.containers.authentik-proxy = {
  #  autoStart = true;
  #  hostname = "authentik-proxy";
  #  image = "docker.io/library/postgres:15-alpine";
  #  ports = ["9000" "9443"];
  #  environment = {
  #    AUTHENTIK_HOST = "https://idp.zah.rocks";
  #    AUTHENTIK_INSECURE = "false";
  #  };
  #  environmentFiles = [config.sops.secrets."authentik/env".path];
  #  extraOptions = ["--net=external"];
  #  dependsOn = ["traefik"];
  #  labels = {
  #    "traefik.enable" = "true";
  #    "traefik.port" = "9000";
  #    # authentik-proxy` refers to the service name in the compose file.
  #    "traefik.http.middlewares.authentik.forwardauth.address" = "http://authentik-proxy:9000/outpost.goauthentik.io/auth/traefik";
  #    "traefik.http.middlewares.authentik.forwardauth.trustForwardHeader" = "true";
  #    "traefik.http.middlewares.authentik.forwardauth.authResponseHeaders" = "X-authentik-username,X-authentik-groups,X-authentik-entitlements,X-authentik-email,X-authentik-name,X-authentik-uid,X-authentik-jwt,X-authentik-meta-jwks,X-authentik-meta-outpost,X-authentik-meta-provider,X-authentik-meta-app,X-authentik-meta-version";
  #  };
  #};
}
