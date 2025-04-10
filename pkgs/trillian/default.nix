{pkgs, lib, fetchFromGitHub, buildGoModule, dockerTools, ...}:
rec {
  trillian = buildGoModule rec {
    pname = "trillian";
    version = "1.7.1";

    src = fetchFromGitHub {
      owner = "google";
      repo = "trillian";
      rev = "v${version}";
      hash = "sha256-TOJqBfYVubwgDF/9i6lwmCLj6x0utzz0O7QJ5SqshCA=";
    };
    vendorHash = "sha256-muPKjhUbpBJBMq8abcgTzq8/bjGXVPLoYHqQJKv8a1k=";

    subPackages = [
      "cmd/trillian_log_signer"
      "cmd/trillian_log_server"
      "cmd/createtree"
    ];
    modroot = ".";

    ldflags = [ "-s" "-w" ];

    meta = {
      description = "A transparent, highly scalable and cryptographically verifiable data store.";
      mainProgram = "trillain_log_server";
      homepage = "https://github.com/google/trillian";
      license = lib.licenses.eupl12;
    };

  };

  container = dockerTools.buildImage {
    name = "docker.io/andrewzah/trillian";
    tag = "${trillian.version}";
    copyToRoot = pkgs.buildEnv {
      name = "trillian-root";
      paths = [
        pkgs.bash
        trillian
      ];
      pathsToLink = ["/bin"];
    };

    config = {
      command = ["--logtostderr"];
      entrypoint = [ "${trillian}/bin/trillian_log_server" ];
      exposedPorts = { "8090" = {}; };
    };
  };
}
