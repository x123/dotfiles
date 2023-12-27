{
  description = "x123 system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable"; # nixos-23.05
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager"; # /release-23.05
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nur.url = "github:nix-community/NUR";
    nix-darwin.url = "github:LnL7/nix-darwin";
    blender-bin.url = "github:edolstra/nix-warez/?dir=blender";
    nixified-ai.url = "github:nixified-ai/flake";

    # minimize duplicate instances of inputs
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    blender-bin.inputs.nixpkgs.follows = "nixpkgs";
    nixified-ai.inputs.nixpkgs.follows = "nixpkgs";
  };
  
  outputs = inputs@{ self, nixpkgs, home-manager, nur, nixos-wsl, nix-darwin, blender-bin, nixos-hardware, nixified-ai, ... }:
  let 
    lib = nixpkgs.lib;

  in {
    homeManagerConfigurations = {
      fom-fom-MBA = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          extra-platforms = "x86_64-darwin";
          config = { allowUnfree = true; };
        };
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./users/fom/home.nix
        ];
      };

      nixos-xnixwsl = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = { allowUnfree = true; };
        };
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./users/nixos/home.nix
        ];
      };

      x-xnix = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = { allowUnfree = true; };
        };
        extraSpecialArgs = {inherit inputs;};
        modules = [
          nur.nixosModules.nur
          ./users/x/home.nix
        ];
      };

      root-nixium = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = { allowUnfree = true; };
        };
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./users/root-nixium/home.nix
        ];
      };

      # UTM based VM
      x-nixos-utm = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-linux";
          config = { allowUnfree = true; };
        };
        extraSpecialArgs = {inherit inputs;};
        modules = [
          nur.nixosModules.nur
          ./users/x-nixos-utm/home.nix
        ];
      };

    };

    darwinConfigurations = {
      fom-MBA = nix-darwin.lib.darwinSystem {
	    system = "aarch64-darwin";
        specialArgs = {inherit inputs;};
	    modules = [
	      home-manager.darwinModules.home-manager
          ./system/fom-MBA/configuration.nix
        ];
      };
    };

    nixosConfigurations = {
      xnixwsl = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          nixos-wsl.nixosModules.wsl
          ./system/xnixwsl/configuration.nix
        ];
      };

      xnix = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
          nixos-hardware.nixosModules.common-pc
          nixos-hardware.nixosModules.common-pc-ssd
          ./system/xnix/configuration.nix
        ];
      };

      xnix-vm = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./system/xnix-vm/configuration.nix
        ];
      };

      nixos-utm = lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./system/nixos-utm/configuration.nix
        ];
      };

      nixium = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./system/nixium/configuration.nix
        ];
        specialArgs = { hostname = "nixium.boxchop.city"; };
      };

    };
  };
}
