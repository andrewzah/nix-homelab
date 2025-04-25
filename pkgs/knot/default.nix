{pkgs, lib, buildGoModule, dockerTools, ...}:
rec {
  knot = buildGoModule rec {
    pname = "knot";
    version = "0.1.0";

    src = fetchGit {
      url = "https://tangled.sh/@tangled.sh/core";
      rev = "ab0a5bd71147b02ec2cd56845d87fbee92367a5e";
      ref = "master";
    };
    vendorHash = "sha256-EilWxfqrcKDaSR5zA3ZuDSCq7V+/IfWpKPu8HWhpndA=";

    subPackages = [
      "cmd/knotserver"
      "cmd/keyfetch"
      "cmd/repoguard"
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
  container = let
    nc = pkgs.netcat-openbsd;
  in dockerTools.buildImage {
    name = "docker.io/andrewzah/knot";
    tag = "${knot.version}";
    copyToRoot = pkgs.buildEnv {
      name = "knot-root";
      paths = [knot];
      pathsToLink = ["/bin"];
    };

    config = {
      Entrypoint = [ "${knot}/bin/knotserver" ];
      ExposedPorts = {
        "22" = {};
        "5555" = {};
      };
      HealthCheck= {
        # nanoseconds
        Interval = 3000000000;
        Timeout = 1000000000;
        StartPeriod = 3000000000;
        Retries = 20;
        Test = ["CMD" "${nc}/bin/nc" "-z" "localhost" "5555"];
      };
    };
  };
}
