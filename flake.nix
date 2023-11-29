{
  description = "x123 system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
  };
  
  outputs = { nixpkgs, home-manager, nur, nixos-wsl, ... }:
  let 
    #system = "x86_64-linux";
    
    pkgs = import nixpkgs {
      #inherit system;
      config = { allowUnfree = true; };  
    };

    lib = nixpkgs.lib;

  in {
    homeManagerConfigurations = {
      nixos = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./users/nixos/home.nix
      ];
    };

      x = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
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
