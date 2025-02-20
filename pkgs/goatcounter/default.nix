{pkgs, lib, buildGoModule, fetchFromGitHub, dockerTools, writeShellScript, ...}:
rec {
  goatcounter = buildGoModule rec {
    pname = "goatcounter";
    version = "c059188a3";

    src = fetchFromGitHub {
      owner = "arp242";
      repo = "goatcounter";
      rev = "c059188a3c6064b2f32f0e80bf029b1eb1b1fdbf";
      hash = "sha256-9oMdaJj2AziNH8aO4Wfdph+D3Ho/0u5uHC59vIJnMKM=";
    };

    vendorHash = "sha256-8W/xQ8jkNjjmaAvdoY/66HCW7dA+pFC4MVc17J/3B5o=";
    subPackages = [ "cmd/goatcounter" ];
    modroot = ".";

    allowReference = true;
    ldflags = [
      "-s"
      "-w"
      "-X zgo.at/goatcounter.Version=${version}"
    ];

    meta = {
      description = "Easy web analytics. No tracking of personal data.";
      mainProgram = "goatcounter";
      homepage = "https://github.com/arp242/goatcounter";
      license = lib.licenses.eupl12;
    };
  };

  container = let
    entrypoint = writeShellScript "entrypoint.sh" ''
      ${goatcounter}/bin/goatcounter serve \
        -port="''${GC_PORT}" \
        -listen="''${GC_LISTEN}" \
        -db="''${GC_DB}" \
        -tls="''${GC_TLS}" \
        -errors="''${GC_ERRORS}" \
        -email-from="''${GC_EMAIL_FROM}" \
        -smtp="''${GOATCOUNTER_SMTP}" \
        -automigrate
    '';
  in dockerTools.buildImage {
    name = "docker.io/andrewzah/goatcounter";
    tag = "${goatcounter.version}";

    config = {
      entrypoint = [ "${entrypoint}" ];
      exposedPorts = { "3443" = {}; };
    };
  };
}
