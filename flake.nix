{
  description = "Andrew's Homelab Flake: WIP";

  outputs = {...} @ inputs: let
    l = builtins // pkgs.lib;
    system = "x86_64-linux";

    pkgs = import inputs.nixpkgs {inherit system;};
    inherit (inputs.nixpkgs.lib) nixosSystem;
  in {
    devShells."${system}".default = pkgs.mkShell {
      packages = with pkgs; [
        age
        sops
        ssh-to-age
      ];
    };

    nixosConfigurations = l.pipe ./hosts [
      (l.readDir)
      (l.filterAttrs (_: type: type == "directory"))
      (l.mapAttrs' (name: _: let
        hostPath = ./hosts + "/${name}";
        hostConfig = import (hostPath + "/config.nix");
      in
        l.nameValuePair name (nixosSystem {
          system = hostConfig.system or "x86_64-linux";
          modules = [
            hostPath
            inputs.sops-nix.nixosModules.sops
          ];
          specialArgs = {inherit hostConfig;};
        })))
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    sops-nix.url = "github:Mic92/sops-nix";
    #nix-hardware.url = "github:NixOS/nixos-hardware/master";
  };
}
