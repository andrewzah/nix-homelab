{
  pkgs,
  attic-server,
  attic-client,
  fetchFromGitHub,
  rustPlatform,
  dockerTools,
  ...
}: let
  common-server = {
    version,
    rev,
    hash,
    cargoHash,
  }:
    attic-server.overrideAttrs (finalAttrs: prevAttrs: {
      inherit version cargoHash;
      src = fetchFromGitHub {
        owner = "andrewzah";
        repo = "attic";
        inherit rev hash;
      };

      cargoDeps = rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) src;
        name = "${prevAttrs.pname}-${finalAttrs.version}";
        hash = cargoHash;
      };
    });

  common-client = {
    version,
    rev,
    hash,
    cargoHash,
  }:
    attic-client.overrideAttrs (finalAttrs: prevAttrs: {
      inherit version cargoHash;
      src = fetchFromGitHub {
        owner = "andrewzah";
        repo = "attic";
        inherit rev hash;
      };
      cargoDeps = rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) src;
        name = "${prevAttrs.pname}-${finalAttrs.version}";
        hash = cargoHash;
      };
    });

  attic-server' = attic-server_2025-07-17;
  attic-server_2025-07-17 = common-server {
    version = "2025-07-17";
    rev = "b26bedfbfc8b0e60be0213c55955af73b443fff5";
    hash = "sha256-xUbSDezBWpReQCzJefuzV+LfAvcISrxcxOUGb7uWPq8=";
    cargoHash = "sha256-NdzwYnD0yMEI2RZwwXl/evYx9zdBVMOUee+V7uq1cf0=";
  };

  attic-client' = attic-client_2025-07-17;
  attic-client_2025-07-17 = common-client {
    version = "2025-07-17";
    rev = "b26bedfbfc8b0e60be0213c55955af73b443fff5";
    hash = "sha256-xUbSDezBWpReQCzJefuzV+LfAvcISrxcxOUGb7uWPq8=";
    cargoHash = "sha256-NdzwYnD0yMEI2RZwwXl/evYx9zdBVMOUee+V7uq1cf0=";
  };
in rec {
  container = dockerTools.buildImage {
    name = "docker.io/andrewzah/attic";
    tag = "${attic-server'.version}";

    copyToRoot = pkgs.buildEnv {
      name = "pkgs-attic-container";
      paths = [attic-client' attic-server'];
      pathsToLink = ["/bin"];
    };

    config = {
      entrypoint = [
        "/bin/atticd"
        "--config"
        "/var/attic/server.toml"
        "--init"
        "--init-token-file"
        "/var/attic/init-token"
      ];
      exposedPorts = {"3443" = {};};
    };
  };
}
