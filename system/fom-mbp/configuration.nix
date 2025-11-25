{pkgs, ...}: {
  imports = [
    ../../modules/nix-settings # do not remove
    ../../modules/system-darwin
  ];

  custom.system-darwin = {
    enable = true;
    ai.enable = true;
  };

  environment = {
    systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        git
        vim
        wget
        ;
    };

    shells = builtins.attrValues {
      inherit
        (pkgs)
        bash
        zsh
        ;
    };

    variables = {
      EDITOR = "vim";
    };
  };

  # allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowAliases = false;
  };

  nix = {
    linux-builder = {
      enable = false;
      ephemeral = true;
      maxJobs = 4;
      config = {
        virtualisation = {
          darwin-builder = {
            diskSize = 40 * 1024;
            memorySize = 6 * 1024;
          };
          cores = 4;
        };
      };
    };

    # nix settings
    settings = {
      extra-platforms = "x86_64-darwin aarch64-darwin";
      allowed-users = [
        "@admin"
        "fom"
      ];
      trusted-users = ["@admin"];
    };
  };

  networking.hostName = "fom-mbp";

  ids.gids.nixbld = 350;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true; # default shell on catalina
    enableCompletion = true;
  };

  programs.bash = {
    enable = true;
    completion.enable = true;
  };

  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
