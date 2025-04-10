{pkgs, rekor-server, rekor-cli, dockerTools, writeShellScript, ...}:
rec {
  container = dockerTools.buildImage {
    name = "docker.io/andrewzah/rekor";
    tag = "${rekor-server.version}";
    copyToRoot = pkgs.buildEnv {
      name = "rekor-root";
      paths = [
        pkgs.bash
        rekor-server
      ];
      pathsToLink = ["/bin"];
    };

    config = {
      entrypoint = [ "${rekor-server}/bin/rekor-server" ];
      exposedPorts = { "3443" = {}; };
    };
  };
}
