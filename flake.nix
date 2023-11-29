{
  description = "x123 system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nur.url = "github:nix-community/NUR";
    nix-darwin.url = "github:LnL7/nix-darwin";

    # minimize duplicate instances of inputs
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  
  outputs = inputs@{ self, nixpkgs, home-manager, nur, nixos-wsl, nix-darwin, ... }:
  let 
    lib = nixpkgs.lib;

  in {
    homeManagerConfigurations = {
      fom-fom-mba14 = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
	  system = "aarch64-darwin";
          config = { allowUnfree = true; };
        };
        modules = [
          ./users/fom/home.nix
      ];
      
      };

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

    darwinConfigurations = {
      fom-mba14 = nix-darwin.lib.darwinSystem {
	system = "aarch64-darwin";
	modules = [
	  home-manager.darwinModules.home-manager
          ./system/fom-mba14/configuration.nix
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
