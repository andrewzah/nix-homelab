eternia:
  nixos-rebuild switch --flake .#eternia --target-host root@eternia --build-host root@eternia

sparrow:
  nixos-rebuild switch --flake .#sparrow --target-host root@sparrow --build-host root@sparrow

falcon:
  nixos-rebuild switch --flake .#falcon --target-host falcon --build-host falcon

updatekeys:
  sops updatekeys secrets.yaml

tree:
  nix-tree --derivation '.#nixosConfigurations.falcon.config.system.build.toplevel'

push:
  git push gh master
  git push origin master
