test HOST USER='zah':
    #!/usr/bin/env bash
    set -euo pipefail

    TARGET="{{ USER }}@{{ HOST }}"

    echo "Testing {{ HOST }} configuration using nixos-rebuild..."
    nixos-rebuild test \
      --flake ".#{{ HOST }}" \
      --build-host "$TARGET" \
      --target-host "${TARGET}" \
      --use-remote-sudo

switch HOST USER='zah':
    #!/usr/bin/env bash
    set -euo pipefail

    TARGET="{{ USER }}@{{ HOST }}"

    echo "Testing {{ HOST }} configuration using nixos-rebuild..."
    nixos-rebuild switch \
      --flake ".#{{ HOST }}" \
      --build-host "$TARGET" \
      --target-host "${TARGET}" \
      --use-remote-sudo

updatekeys:
  sops updatekeys secrets.yaml
  sops updatekeys hosts/blanka/secrets.yaml
  sops updatekeys hosts/lumiere/secrets.yaml

tree HOST:
  nix-tree --derivation '.#nixosConfigurations.{{ HOST }}.config.system.build.toplevel'
