{...}: {
  virtualisation.oci-containers.containers.scrutiny = {
    autoStart = true;
    image = "ghcr.io/analogj/scrutiny:master-web@sha256:120e271f71b74de976502fedd5dc691c730a9ae1e117a38fd4e61371e69ff483 ";
    extraOptions = ["--cap-add=SYS_RAWIO"];
    ports = ["21080:8080"];
    volumes = [
      "/run/udev:/run/udev:ro"
    ];
    devices = [
      "/dev/sda"
      "/dev/sdb"
      "/dev/sdc"
      "/dev/sdd"
      "/dev/sde"
      "/dev/sdf"
      "/dev/sdg"
      "/dev/sdh"
      "/dev/sdi"
      "/dev/sdj"
      "/dev/sdk"
      "/dev/sdl"
    ];
  };
}
