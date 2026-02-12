{config, ...}: {
  sops.secrets."memcached/env" = {};

  virtualisation.oci-containers.containers.memcached = {
    autoStart = true;
    hostname = "memcached";
    image = "docker.io/library/memcached:1.6-alpine3.23@sha256:8a82a3927694e42bc52679dc81532244de51e5faed5f9541a1283e3ad7271db1";
    ports = ["11211"];
    environmentFiles = [config.sops.secrets."memcached/env".path];
    cmd = [
      "sh"
      "-euc"
      ''
        echo 'mech_list: plain' > "$$SASL_CONF_PATH"
        echo "zulip@$$HOSTNAME:$$MEMCACHED_PASSWORD" > "$$MEMCACHED_SASL_PWDB"
        echo "zulip@localhost:$$MEMCACHED_PASSWORD" >> "$$MEMCACHED_SASL_PWDB"
        exec memcached -S
      ''
    ];
    volumes = [
      "/lumiere/data/docker/memcached/config/:/config/:rw"
    ];
    environment.TZ = config.time.timeZone;
    extraOptions = ["--net=internal"];
  };
}
