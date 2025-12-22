{
  description = "Andrew's Homelab Flake: WIP";

  outputs = {
    self,
    nixpkgs,
    sops-nix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
    inherit (nixpkgs.lib) nixosSystem;
  in {
    devShells."${system}".default = pkgs.mkShellNoCC {
      packages = with pkgs; [
        age
        sops
        ssh-to-age
      ];
    };

    nixosConfigurations = {
      # dev machine; currently WNDWKR02 SFF
      sparrow = nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/sparrow/default.nix
          sops-nix.nixosModules.sops
        ];
      };

      # framework
      eternia = nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/eternia/default.nix
          sops-nix.nixosModules.sops
        ];
      };

      # ben server
      lumiere = nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/lumiere/default.nix
          sops-nix.nixosModules.sops
        ];
      };

      # dad server
      nappa = nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/nappa/default.nix
          sops-nix.nixosModules.sops
        ];
      };

      # da server
      blanka = nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/blanka/default.nix
          sops-nix.nixosModules.sops
        ];
      };
    };
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    sops-nix.url = "github:Mic92/sops-nix";

    #home-manager.url = "github:nix-community/home-manager/release-24.05";
    #home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #nix-hardware.url = "github:NixOS/nixos-hardware/master";
  };
}
