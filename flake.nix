{
  description = "x123 system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable"; # nixos-23.05
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager"; # /release-23.05
    sops-nix.url = "github:Mic92/sops-nix";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nur.url = "github:nix-community/NUR";
    nix-darwin.url = "github:LnL7/nix-darwin";
    blender-bin.url = "github:edolstra/nix-warez/?dir=blender";
    nixified-ai.url = "github:nixified-ai/flake";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    ghostty.url = "git+ssh://git@me.github.com/mitchellh/ghostty";

    # minimize duplicate instances of inputs
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #sops-nix.inputs.nixpkgs.follows = "nixpkgs"; # optional, not necessary
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    blender-bin.inputs.nixpkgs.follows = "nixpkgs";
    nixified-ai.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    sops-nix,
    nixos-wsl,
    nur,
    nix-darwin,
    blender-bin,
    nixified-ai,
    ghostty,
    pre-commit-hooks,
    ...
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          inherit system;
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    checks = forEachSupportedSystem ({
      pkgs,
      system,
    }: {
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        default_stages = ["push" "manual"];
        hooks = {
          alejandra.enable = true;
          shellcheck.enable = true;
          statix.enable = true;
        };
        settings = {
          alejandra = {
            check = true;
            #verbosity = "quiet";
          };
        };
      };
    });

    devShells = forEachSupportedSystem ({
      pkgs,
      system,
    }: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          age
          alejandra
          nvd
          shellcheck
          sops
          ssh-to-age
          statix
          vulnix
        ];

        shellHook = ''
          export PATH="$PWD/bin:$PATH"
          ${self.checks.${system}.pre-commit-check.shellHook}
        '';
      };
    });

    homeManagerConfigurations = {
      fom-fom-MBA = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          extra-platforms = "x86_64-darwin";
          config = {allowUnfree = true;};
        };
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./users/fom/home.nix
        ];
      };

      nixos-xnixwsl = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = {allowUnfree = true;};
        };
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./users/nixos/home.nix
        ];
      };

      x-xnix = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = {allowUnfree = true;};
        };
        extraSpecialArgs = {inherit inputs;};
        modules = [
          nur.nixosModules.nur
          ./users/x-xnix/home.nix
        ];
      };

      root-nixium = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = {allowUnfree = true;};
        };
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./users/root-nixium/home.nix
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
      xnixwsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          nixos-wsl.nixosModules.wsl
          ./system/xnixwsl/configuration.nix
        ];
      };

      xnix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
          nixos-hardware.nixosModules.common-pc
          nixos-hardware.nixosModules.common-pc-ssd
          sops-nix.nixosModules.sops
          ./system/xnix/configuration.nix
        ];
      };

      nixium = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          hostname = "nixium.boxchop.city";
        };
        modules = [
          ./system/nixium/configuration.nix
          sops-nix.nixosModules.sops
          #sops-nix.modules.home-manager.sops
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.root = import ./users/root-nixium/home.nix;
              extraSpecialArgs.flake-inputs = inputs;
            };
          }
        ];
      };
    };
  };
}
