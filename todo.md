## when possible

- push & update nixseoul.club sha
- https://github.com/dgtlmoon/changedetection.io?tab=readme-ov-file
- refactor machines to use metadata/etc to provision machine details, user info,
  etc, in a standard way

## to investigate

- postgres fixup:
  - ? custom image + entrypoint.sh
  - nix: write init.sh scripts to $dir
  - systemd oneshot / timer: exec command within postgres container to run
    `docker_process_init_files`:
    https://github.com/docker-library/postgres/blob/729d22b104ede82d7b2d8681bb85f2f44c33eb60/docker-entrypoint.sh

## security

- look into crowdsec https://github.com/crowdsecurity/crowdsec
- network scanning & alerting: https://github.com/jokob-sk/NetAlertX

## metrics, stats

- node_exporter & prometheus / influxdb
- grafana

## social / games

- minecraft ?

## consider hard before adding

- immich - nix module?

## research / inspiration

- https://github.com/badele/nix-homelab/tree/main/hosts
