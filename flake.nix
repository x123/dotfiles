{
  description = "x123 system config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable-small.url = "nixpkgs/nixos-unstable-small";
    ghostty.url = "github:ghostty-org/ghostty";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nur.url = "github:nix-community/NUR";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs"; # optional, not necessary
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lexical = {
      url = "github:lexical-lsp/lexical";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stevenblack = {
      url = "github:StevenBlack/hosts";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable-small,
    nixos-hardware,
    home-manager,
    sops-nix,
    nur,
    nix-darwin,
    ghostty,
    pre-commit-hooks,
    disko,
    lexical,
    stevenblack,
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
          markdownlint.enable = true;
          markdownlint.settings = {
            configuration = {
              "MD007" = {
                "indent" = 4;
                "start_indent" = 4;
              };
              "MD013" = {
                "tables" = false;
              };
              "MD025" = false;
              "MD029" = {
                "style" = "one_or_ordered";
              };
              "MD041" = false;
            };
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
            ;
        };

        shellHook = ''
          export PATH="$PWD/bin:$PATH"
          ${self.checks.${system}.pre-commit-check.shellHook}
        '';
      };
    });

    homeConfigurations = {
      "fom@fom-mbp" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          extra-platforms = "x86_64-darwin";
          config = {
            allowUnfree = true;
            allowAliases = false;
          };
        };
        extraSpecialArgs = {
          inherit inputs;
          system = "aarch64-darwin";
        };
        modules = [
          ./system/fom-mbp/users/fom/home.nix
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
        extraSpecialArgs = {
          inherit inputs;
          system = "x86_64-linux";
        };
        modules = [
          nur.modules.homeManager.default
          ./system/xnix/users/x/home.nix
        ];
      };

      "x@nixpad" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
            cudaSupport = false;
            allowAliases = false;
          };
        };
        extraSpecialArgs = {
          inherit inputs;
          system = "x86_64-linux";
        };
        modules = [
          nur.modules.homeManager.default
          ./system/nixpad/users/x/home.nix
        ];
      };

      "x@vm" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-linux";
          config = {
            allowUnfree = true;
            cudaSupport = false;
            allowAliases = false;
            allowUnsupportedSystem = true;
          };
        };
        extraSpecialArgs = {
          inherit inputs;
          system = "aarch64-linux";
        };
        modules = [
          nur.modules.homeManager.default
          ./system/vm/users/x/home.nix
        ];
      };
    };

    darwinConfigurations = {
      fom-mbp = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit inputs;};
        modules = [
          home-manager.darwinModules.home-manager
          ./system/fom-mbp/configuration.nix
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
          hostname = "hetznix.nixlink.net";
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
              extraSpecialArgs = {
                inherit inputs;
                # system = "aarch64-linux";
              };
            };
          }
        ];
      };

      mininix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          system = "x86_64-linux";
          hostname = "mininix.empire.internal";
        };
        modules = [
          disko.nixosModules.disko
          ./system/mininix/configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
              };
            };
          }
        ];
      };

      privnix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          system = "x86_64-linux";
          hostname = "privnix.empire.internal";
        };
        modules = [
          disko.nixosModules.disko
          ./system/privnix/configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
              };
            };
          }
        ];
      };

      wgnix-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          system = "x86_64-linux";
          hostname = "wgnix-vm.empire.internal";
        };
        modules = [
          disko.nixosModules.disko
          ./system/wgnix-vm/configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
              };
            };
          }
        ];
      };

      transmission = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          system = "x86_64-linux";
          hostname = "transmission.empire.internal";
        };
        modules = [
          disko.nixosModules.disko
          ./system/transmission/configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
              };
            };
          }
        ];
      };

      unboundednix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          system = "x86_64-linux";
          hostname = "unboundednix.empire.internal";
        };
        modules = [
          ./system/unboundednix/configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
              };
            };
          }
        ];
      };

      vm = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs;
          system = "aarch64-linux";
          hostname = "vm.local";
        };
        modules = [
          disko.nixosModules.disko
          ./system/vm/configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
              };
            };
          }
        ];
      };
    };
  };
}
