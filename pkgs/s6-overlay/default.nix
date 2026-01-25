{
  lib,
  stdenv,
  fetchurl,
  ...
}: let
  sources = builtins.fromJSON (builtins.readFile ./source.json);

  archMap = {
    "x86_64-linux" = "x86_64";
    "aarch64-linux" = "aarch64";
  };
  common = version: arch:
    stdenv.mkDerivation rec {
      name = "s6-overlay";
      inherit version;

      srcs = [
        (fetchurl {
          url = "https://github.com/just-containers/s6-overlay/releases/download/v${version}/s6-overlay-${archMap."${arch}"}.tar.xz";
          hash = sources."${version}"."${arch}".arch;
        })
        (fetchurl {
          url = "https://github.com/just-containers/s6-overlay/releases/download/v${version}/s6-overlay-noarch.tar.xz";
          hash = sources."${version}"."${arch}".noarch;
        })
      ];
      sourceRoot = ".";

      unpackPhase = ''
        mkdir ./root/

        for src in $srcs; do
          tar --no-same-owner -C ./root/ -Jxf "$src"
          mkdir -p $out
          cp -r ./root/* $out/
        done

        # to prevent using / in pkgs.buildEnv.pathsToLink
        mv $out/init $out/command/init
      '';
      installPhase = ''
        mkdir -p $out/run $out/var
        ln -s $out/run $out/var/run

        mkdir -p $out/var/empty
      '';

      postFixup = ''
        # this only exists for legacy reasons, and
        # interferes with k8s stuff
        sed -i \
          's#if test -L /var/run && test "`s6-linkname -f /var/run`" = /run ; then : ; else#if [ 1 -eq 0 ]; then#' \
          $out/package/admin/s6-overlay/libexec/preinit
      '';

      meta = {
        description = "6 overlay for containers (includes execline, s6-linux-utils & a custom init)";
        homepage = "https://skarnet.org/software/s6-rc/";
        changelog = "https://github.com/just-containers/s6-overlay/releases";
        platforms = builtins.attrNames sources."3.2.1.0";
        license = lib.licenses.isc;
      };
    };
in {
  s6-overlay = common "3.2.1.0" "x86_64-linux";
}
