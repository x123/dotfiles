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
    system = "x86_64-linux";
    
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };  
    };

    lib = nixpkgs.lib;

  in {
    homeManagerConfigurations = {
      nixos = home-manager.lib.homeManagerConfiguration {
	inherit pkgs;
	modules = [
	{
	  home = {
	    username = "nixos";
            homeDirectory = "/home/nixos";
            stateVersion = "23.05";
 	    packages = with pkgs; [
	    # term/shell
	    file
	    htop
	    pciutils
	    ripgrep
	    tmux
	    usbutils
	    whois

	    # net
	    aria2

	    # dev
	    git
	    git-crypt
	    rocgdb # for strings

	    # crypto
	    age
	    gnupg
	    sops

	    # archives
	    unzip
	    zip

	    # network tools
	    dnsutils
	    ethtool
	    ipcalc
	    mtr
	    nmap

	    # misc
	    pinentry

	    # system tools
	    lm_sensors
	    sysstat
	  ];
          };
	}
	];
      };

      x = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        #pkgs = nixpkgs.legacyPackages.${system};

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
        inherit system;

        modules = [
	  nixos-wsl.nixosModules.wsl
          ./system/xnixwsl/configuration.nix
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
