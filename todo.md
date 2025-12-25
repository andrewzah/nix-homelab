## current prio!

- ersatz tv
- https://otterwiki.com/Configuration
- rss reader
- sync phone contacts w/ caldav (baikal?)

## general

- distributed file hosting:
  https://github.com/deuxfleurs-org/garage?ref=selfh.st
- pdf tools: bentopdf instead of sterlingpdf
- monitoring:
  - https://beszel.dev/
- collaborative docs:
  - https://github.com/suitenumerique/docs
- https://github.com/defnull/fediwall
- fix minecraft server sleeping:
  - https://github.com/joesturge/lazymc-docker-proxy?tab=readme-ov-file
  - https://docker-minecraft-server.readthedocs.io/en/latest/misc/examples/#lazymc-put-your-minecraft-server-to-rest-when-idle
- migrate / cluster vaultwarden to KR servers
- look into colmena/clan.lol
- https://github.com/mautrix/telegram
- jails? https://git.sr.ht/~alexdavid/jail.nix
- syncthing: https://pastebin.com/FrSgKRYm
- automate openldap?
- forgejo / codeberg code host - CI builds?

- https://github.com/docmost/docmost
- https://github.com/outline/outline

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
