eternia:
  nixos-rebuild switch --flake .#eternia --target-host root@eternia --build-host root@eternia

sparrow:
  nixos-rebuild switch --flake .#sparrow --target-host root@sparrow --build-host root@sparrow

falcon:
  nixos-rebuild switch --flake .#falcon --target-host falcon --build-host falcon

blanka:
  nixos-rebuild switch --flake .#blanka --target-host blanka --build-host blanka

updatekeys:
  sops updatekeys secrets.yaml
  sops updatekeys hosts/blanka/secrets.yaml
  sops updatekeys hosts/lumiere/secrets.yaml

tree:
  nix-tree --derivation '.#nixosConfigurations.falcon.config.system.build.toplevel'

push:
  git push gh master
  #git push origin master
