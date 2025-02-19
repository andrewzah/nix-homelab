eternia:
  nixos-rebuild switch --flake .#eternia --target-host root@eternia --build-host root@eternia

sparrow:
  nixos-rebuild switch --flake .#sparrow --target-host root@sparrow --build-host root@sparrow

falcon:
  nixos-rebuild switch --flake .#falcon --target-host falcon --build-host falcon

updatekeys:
  sops updatekeys secrets.yaml
