{
  description = "x123 system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # nixpkgs-unstable-small.url = "nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    sops-nix.url = "github:Mic92/sops-nix";
    nur.url = "github:nix-community/NUR";
    nix-darwin.url = "github:LnL7/nix-darwin";
    blender-bin.url = "github:edolstra/nix-warez/?dir=blender";
    nixified-ai.url = "github:nixified-ai/flake";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    disko.url = "github:nix-community/disko";

    narsil-flake.url = "github:x123/narsil-flake";
    ghostty.url = "git+ssh://git@me.github.com/ghostty-org/ghostty";
    lexical.url = "github:lexical-lsp/lexical";

    # minimize duplicate instances of inputs
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #sops-nix.inputs.nixpkgs.follows = "nixpkgs"; # optional, not necessary
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    blender-bin.inputs.nixpkgs.follows = "nixpkgs";
    nixified-ai.inputs.nixpkgs.follows = "nixpkgs";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    lexical.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    # nixpkgs-unstable-small,
    nixos-hardware,
    home-manager,
    sops-nix,
    nur,
    nix-darwin,
    blender-bin,
    nixified-ai,
    ghostty,
    pre-commit-hooks,
    disko,
    lexical,
    narsil-flake,
    ...
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          inherit system;
          pkgs = import nixpkgs {
            inherit system;
          };
        });
  in {
    checks = forEachSupportedSystem ({
      pkgs,
      system,
    }: {
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          alejandra.enable = true;
          alejandra.settings = {
            check = true;
          };
          deadnix.enable = true;
          deadnix.settings = {
            noLambdaArg = true;
            noLambdaPatternNames = true;
          };
          shellcheck.enable = true;
          statix.enable = false;
        };
      };
    });

    devShells = forEachSupportedSystem ({
      pkgs,
      system,
    }: {
      default = pkgs.mkShell {
        packages = builtins.attrValues {
          inherit
            (pkgs)
            age
            alejandra
            deadnix
            nvd
            shellcheck
            sops
            ssh-to-age
            statix
            vulnix
            ;
        };

        shellHook = ''
          export PATH="$PWD/bin:$PATH"
          ${self.checks.${system}.pre-commit-check.shellHook}
        '';
      };
    });

    homeConfigurations = {
      "fom@fom-MBA" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          extra-platforms = "x86_64-darwin";
          config = {
            allowUnfree = true;
            allowAliases = false;
          };
        };
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./system/fom-MBA/users/fom/home.nix
        ];
      };

      "x@xnix" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
            cudaSupport = true;
            allowAliases = false;
          };
        };
        extraSpecialArgs = {inherit inputs;};
        modules = [
          nur.nixosModules.nur
          ./system/xnix/users/x/home.nix
        ];
      };

      "x@nixpad" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
            cudaSupport = true;
            allowAliases = false;
          };
        };
        extraSpecialArgs = {inherit inputs;};
        modules = [
          nur.nixosModules.nur
          ./system/nixpad/users/x/home.nix
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
      xnix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-cpu-amd-zenpower
          nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
          nixos-hardware.nixosModules.common-pc
          nixos-hardware.nixosModules.common-pc-ssd
          sops-nix.nixosModules.sops
          ./system/xnix/configuration.nix
        ];
      };

      nixpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-t480s
          sops-nix.nixosModules.sops
          ./system/nixpad/configuration.nix
        ];
      };

      hetznix = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs;
          system = "aarch64-linux";
          hostname = "hetznix.boxchop.city";
        };
        modules = [
          disko.nixosModules.disko
          ./system/hetznix/configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs;};
            };
          }
        ];
      };
    };
  };
}
