{
  description = "x123 system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  
  outputs = { nixpkgs, home-manager, ... }:
  let 
    system = "x86_64-linux";
    
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };  
    };

    lib = nixpkgs.lib;

  in {
    homeManagerConfigurations = {
      x = home-manager.lib.homeManagerConfiguration {
        #inherit system;
        inherit pkgs;
        #pkgs = nixpkgs.legacyPackages.${system};

        modules = [
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
      xnix = lib.nixosSystem {
        inherit system;

        modules = [
          ./system/configuration.nix
          #home-manager.nixosModules.home-manager
          #{
          #  home-manager.useGlobalPkgs = true;
          #  home-manager.useUserPackages = true;
          #  home-manager.users.x = import ./users/x/home.nix;
          #
          #  # Optionally, use home-manager.extraSpecialArgs to pass
          #  # arguments to home.nix
          #}
        ];  
      };      
    };
  };
}
