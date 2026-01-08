{
  pkgs,
  lib,
  buildGoModule,
  fetchFromGitHub,
  dockerTools,
  writeShellScript,
  ...
}: rec {
  goatcounter = buildGoModule rec {
    pname = "goatcounter";
    version = "2.7.0.1";

    src = fetchFromGitHub {
      owner = "arp242";
      repo = "goatcounter";
      rev = "9903e20a14297615a3bcb27c25669a572ca5d201";
      hash = "sha256-utqKhXmqow7oItAe+quy2+FWUvwZADBQ3rCmMGyfzZE=";
    };

    vendorHash = "sha256-cRABpWKp5FFSQ2l8a5Sk1tYoXq6EMUGlpd5HU8u2A5s=";
    subPackages = ["cmd/goatcounter"];
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
  in
    dockerTools.buildImage {
      name = "docker.io/andrewzah/goatcounter";
      tag = "${goatcounter.version}";

      copyToRoot = pkgs.buildEnv {
        name = "image-root";
        paths = [goatcounter];
      };

      config = {
        entrypoint = ["${entrypoint}"];
        exposedPorts = {"3443" = {};};
      };
    };
}
