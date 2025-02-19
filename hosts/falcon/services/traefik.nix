{config, ...}: {
  sops.secrets."traefik" = {};

  virtualisation.oci-containers.containers.traefik = {
    autoStart = true;
    image = "docker.io/library/traefik:v3.1.4@sha256:6215528042906b25f23fcf51cc5bdda29e078c6e84c237d4f59c00370cb68440";
    ports = [
      #"22:22"
      "80:80"
      "443:443"
      "8080:8080"
      "11371:11371"
    ];
    environmentFiles = [
      config.sops.secrets."traefik/CLOUDFLARE_EMAIL".path
      config.sops.secrets."traefik/CLOUDFLARE_DNS_API_TOKEN".path
    ];
  };
}
