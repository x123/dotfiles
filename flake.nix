{
  description = "x123 system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nur.url = "github:nix-community/NUR";

    # minimize duplicate instances of inputs
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
  };
  
  outputs = { nixpkgs, home-manager, nur, nixos-wsl, ... }:
  let 
    lib = nixpkgs.lib;

  in {
    homeManagerConfigurations = {
      nixos-xnixwsl = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = { allowUnfree = true; };
        };
        modules = [
          ./users/nixos/home.nix
      ];
    };

      x-xnix = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = { allowUnfree = true; };
        };
        modules = [
          nur.nixosModules.nur
          ./users/x/home.nix
          {
            home = {
              username = "x";
              homeDirectory = "/home/x";
              stateVersion = "23.05";
            };
          }
        ];
      };
    };
    
    nixosConfigurations = {
      xnixwsl = lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          nixos-wsl.nixosModules.wsl
          ./system/xnixwsl/configuration.nix
        ];
      };

      xnix = lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./system/xnix/configuration.nix
        ];
      };
    };

  };
}
