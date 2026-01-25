{
  knot,
  dockerTools,
  buildEnv,
  writeTextDir,
  fakeNss,
  openssh,
  netcat-openbsd,
  callPackage,
  symlinkJoin,
  pkgs,
  ...
}: let
  s6-overlay = (callPackage ../s6-overlay {}).s6-overlay;
  s6Merged = symlinkJoin {
    name = "s6-merged";
    paths = [s6-overlay ./root];
  };
  nc = netcat-openbsd;

  fakeNss' = fakeNss.override {
    extraPasswdLines = [
      "git:x:10000:10000:new user:/var/empty:/bin/nologin"
      "sshd:x:996:994:SSH privilege separation user:/var/empty:/bin/nologin"
    ];
    extraGroupLines = ["git:x:10000:"];
  };

  openssh' = pkgs.runCommand "openssh-custom" {} ''
    mkdir -p $out/etc/ssh
    cp -r ${pkgs.openssh}/* $out/
    chmod -R u+w $out/etc/ssh

    echo "Include /etc/ssh/sshd_config.d/*.conf" >> $out/etc/ssh/sshd_config
  '';

  authorizedKeysCommand = writeTextDir "/etc/ssh/sshd_config.d/tangled_sshd.conf" ''
    HostKey /etc/ssh/keys/ssh_host_rsa_key
    HostKey /etc/ssh/keys/ssh_host_ecdsa_key
    HostKey /etc/ssh/keys/ssh_host_ed25519_key

    PasswordAuthentication no

    Match User git
      AuthorizedKeysCommand /etc/s6-overlay/scripts/keys-wrapper
      AuthorizedKeysCommandUser nobody
  '';
in
  dockerTools.buildImage {
    name = "docker.io/andrewzah/knot";
    tag = "${knot.version}";

    copyToRoot = buildEnv {
      name = "knot-root";
      paths = [
        knot
        openssh'
        dockerTools.caCertificates
        dockerTools.binSh
        pkgs.busybox

        fakeNss'
        authorizedKeysCommand
        s6Merged
      ];
      pathsToLink = [
        "/bin"
        "/command"
        "/etc"
        "/include"
        "/lib"
        "/libexec"
        "/package"
        "/var"
      ];
    };

    config = {
      Entrypoint = ["/command/init"];
      Environment = ["PATH=/command:/bin"];

      ExposedPorts = {
        "5555" = {};
        "22" = {};
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
