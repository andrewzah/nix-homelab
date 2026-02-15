{config, ...}: {
  sops.secrets."continuwuity/env" = {};

  virtualisation.oci-containers.containers.continuwuity = {
    autoStart = true;
    image = "forgejo.ellis.link/continuwuation/continuwuity:latest@sha256:1f31ad44e692c9ab0a4f39a7111e8ad9dfef0f251f0a864fe05667c152f1f5c1";
    ports = ["6167" "8448"];
    environmentFiles = [config.sops.secrets."continuwuity/env".path];
    volumes = [
      "/blanka/continuwuity/data/:/var/lib/continuwuity/:rw"
      "/etc/resolv.conf:/etc/resolv.conf:ro"
    ];
    extraOptions = ["--net=external"];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.continuwuity.rule" = "Host(`matrix.andrewzah.com`) || (Host(`andrewzah.com`) && PathPrefix(`/.well-known/matrix`))) ";
      "traefik.http.routers.continuwuity.entrypoints" = "websecure";
      "traefik.http.routers.continuwuity.tls.certresolver" = "cloudflare";
    };
  };
}
