{
  pkgs,
  lib,
  buildGoModule,
  ...
}: rec {
  knot = buildGoModule {
    pname = "knot";
    version = "0.11.0-unstable-26-1-25";

    src = fetchGit {
      url = "https://tangled.sh/@tangled.sh/core";
      rev = "8fab832af89cb344048a9bb52740044211a5372b";
      ref = "master";
    };
    vendorHash = "sha256-aHJWmrfba7dAwiUJQvGW1r8zr8askb2B86cRAuc8zwk=";

    subPackages = [
      "cmd/knot"
    ];
    modroot = ".";

    # go build -ldflags="-help"
    ldflags = [
      "-s" # disable symbol table
      "-w" # disable dwarf generation
    ];

    meta = {
      description = "knot server for tangled.sh";
      mainProgram = "knotserver";
      homepage = "https://tangled.sh/@tangled.sh/core";
      license = lib.licenses.mit;
    };
  };

  # add git user
  container = pkgs.callPackage ./container.nix {inherit knot;};
}
