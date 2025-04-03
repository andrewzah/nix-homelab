## utmost priority
- IDP + forward-auth - keycloak v. authentik
  - user provisioning

## general
- postgres fixup:
  - ? custom image + entrypoint.sh
  - nix: write init.sh scripts to $dir
  - systemd oneshot / timer: exec command within postgres container to run
    `docker_process_init_files`: https://github.com/docker-library/postgres/blob/729d22b104ede82d7b2d8681bb85f2f44c33eb60/docker-entrypoint.sh

## security
- look into crowdsec
  https://github.com/crowdsecurity/crowdsec
- tailscale ?
- idp: kanidm vs authentik vs keycloak
  - https://github.com/oauth2-proxy/oauth2-proxy
- network scanning & alerting: https://github.com/jokob-sk/NetAlertX

## metrics, stats
- node_exporter & prometheus / influxdb
- goatcounter2
- grafana ?

## utilities
- chef.zah.rocks - cyberchef

## social / games
- minecraft ?
- cockatrice

## consider hard before adding
- (dashboard) https://github.com/glanceapp/glance
- immich - nix module?

## research / inspiration
- https://github.com/badele/nix-homelab/tree/main/hosts
