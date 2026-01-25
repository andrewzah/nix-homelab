{
  pkgs,
  lib,
  buildGoModule,
  glibc,
  pkg-config,
  ...
}: rec {
  knot = buildGoModule (finalAttrs: {
    pname = "knot";
    version = "1.11.0-alpha";

    nativeBuildInputs = [pkg-config];
    buildInputs = [glibc.static];

    src = fetchGit {
      url = "https://tangled.sh/@tangled.sh/core";
      ref = "refs/tags/v${finalAttrs.version}";
    };
    vendorHash = "sha256-yPLS7JCTqHvWYMp3opn3aqm7ImGQTLYK0qIOmQU9YLk="; # 0.11.0-alpha
    #vendorHash = "sha256-YAG39KDuurwajlt0XR+OK8DF8C9fcEDrcg/LowcZ2eE=";

    subPackages = ["cmd/knot"];
    modroot = ".";

    env.CGO_ENABLED = true;

    # go build -ldflags="-help"
    ldflags = [
      "-s" # disable symbol table
      "-w" # disable dwarf generation
      "-extldflags '-static'"
    ];

    meta = {
      description = "knot server for tangled.sh";
      mainProgram = "knotserver";
      homepage = "https://tangled.sh/@tangled.sh/core";
      license = lib.licenses.mit;
    };
  });

  container = pkgs.callPackage ./container.nix {inherit knot;};
}
