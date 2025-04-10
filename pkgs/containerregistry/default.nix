{pkgs, lib, dockerTools, buildGoModule, fetchFromGitHub, ...}:
rec {
  registry = buildGoModule rec {
    pname = "container-registry";
    version = "0.20.3";

    src = fetchFromGitHub {
      owner = "google";
      repo = "go-containerregistry";
      rev = "v${version}";
      hash = "sha256-HiksVzVuY4uub7Lwfyh3GN8wpH2MgIjKSO4mQJZeNvs=";
    };
    vendorHash = null;
    subPackages = ["cmd/crane"];
    ldflags = [ "-s" "-w" ];

    meta = {
      description = "Go library and CLIs for working with container registries.";
      mainProgram = "registry";
      homepage = "https://github.com/google/go-containerregistry";
      license = lib.licenses.apsl20;
    };
  };

  container = dockerTools.buildImage {
    name = "docker.io/andrewzah/container-registry";
    tag = "${registry.version}";
    copyToRoot = pkgs.buildEnv {
      name = "rekor-root";
      paths = [pkgs.bash registry];
      pathsToLink = ["/bin"];
    };

    config = {
      entrypoint = ["${registry}/bin/crane"];
      exposedPorts = { "1338" = {}; };
    };
  };
}
