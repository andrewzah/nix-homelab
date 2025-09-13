## prio

- notes: determine app
  - https://notesnook.com/
    - https://github.com/beardedtek/notesnook-docker
    - https://github.com/streetwriters/notesnook
    - https://github.com/streetwriters/notesnook-sync-server
  - https://github.com/TriliumNext/Trilium
  - https://github.com/docmost/docmost
  - https://github.com/outline/outline
- https://github.com/sissbruecker/linkding

## when possible

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
