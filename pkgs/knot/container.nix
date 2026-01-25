{
  pkgs,
  knot,
  dockerTools,
  buildEnv,
  writeTextDir,
  fakeNss,
  openssh,
  netcat-openbsd,
  ...
}: let
  nc = netcat-openbsd;

  fakeNss' = fakeNss.override {
    extraPasswdLines = ["git:x:10000:10000:new user:/var/empty:/bin/nologin"];
    extraGroupLines = ["git:x:10000:"];
  };

  authorizedKeysCommand = writeTextDir "/etc/ssh/sshd_config.d/authorized_keys_command.conf" ''
    Match User git
      AuthorizedKeysCommand /usr/local/bin/knot keys -o authorized-keys
      AuthorizedKeysCommandUser nobody
    EOF
  '';
in
  dockerTools.buildImage {
    name = "docker.io/andrewzah/knot";
    tag = "${knot.version}";

    copyToRoot = buildEnv {
      name = "knot-root";
      paths = [
        knot
        fakeNss'
        openssh
        authorizedKeysCommand
      ];
      pathsToLink = ["/bin" "/etc"];
    };

    config = {
      Entrypoint = ["${knot}/bin/knot"];
      Cmd = ["server"];
      ExposedPorts = {
        "22" = {};
        "5555" = {};
      };
      HealthCheck = {
        # nanoseconds
        Interval = 3000000000;
        Timeout = 1000000000;
        StartPeriod = 3000000000;
        Retries = 20;
        Test = ["CMD" "${nc}/bin/nc" "-z" "localhost" "5555"];
      };
    };
  }
