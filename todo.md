## lumiere

- ! idp: keycloak
- https://github.com/glanceapp/glance
- inbound request monitoring + automated firewall banning
- homepage/launchpage to keep track of services
  - https://github.com/Lissy93/dashy
  - https://gethomepage.dev/
- monitoring/dashboard: prometheus + netdata + influx + grafana + thanos
- UPS data

---

- request manager: https://github.com/seerr-team/seerr
- vaultwarden
- linkding
- ! OIDC: keycloak alternative,
  https://github.com/pocket-id/pocket-id?tab=readme-ov-file
- manga:
  - kavita: https://github.com/Kareadita/Kavita
  - or komga: https://komga.org/
  - downloading: suwayomi
- ebooks: booklore: https://github.com/booklore-app/booklore
- ersatz tv + jellyfin integration
- small wikis: https://otterwiki.com/Configuration
- recipes: https://docs.mealie.io/
- atuin: e2ee sync shell history
- notes:
  - hedgedoc

## general

- dns: https://technitium.com/dns/
- monitoring:
  - healthchecks.io
  - uptime kuma
  - https://github.com/TwiN/gatus
  - https://github.com/dgtlmoon/changedetection.io
- metrics/dashboard
  - grafana
  - prometheus
  - telegraf / node_exporter
  - https://github.com/Checkmk/checkmk
- ntfy/gotify -> pushover
- https://github.com/louislam/uptime-kuma
- rss reader
- sync phone contacts w/ caldav (baikal?)
- file mgmt: https://github.com/cloudreve/cloudreve
- paperless-ngx
- automation: https://github.com/n8n-io/n8n
- docker registry?
  - https://hub.docker.com/_/registry
  - https://github.com/Joxit/docker-registry-ui

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
