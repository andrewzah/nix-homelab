{
  pkgs,
  lib,
  buildEnv,
  galene,
  cacert,
  ...
}: {
  container = pkgs.dockerTools.buildImage {
    name = "docker.io/andrewzah/galene";
    tag = "${galene.version}";

    copyToRoot = buildEnv {
      name = "image-root";
      paths = [galene cacert];
    };

    config.Entrypoint = "${lib.getExe' galene "galene"}";
    config.WorkingDir = "/config";
  };
}
