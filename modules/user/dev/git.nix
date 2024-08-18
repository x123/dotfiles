{
  inputs,
  pkgs,
  system,
  ...
}: {
  nixpkgs.overlays = [
    (
      final: prev: {
        unstable-small = import inputs.nixpkgs-unstable-small {
          inherit system;
        };
      }
    )
  ];
  imports = [];

  home = {
    packages = builtins.attrValues {
      inherit
        (pkgs)
        github-cli
        gitleaks
        ;
    };
  };

  programs.git = {
    enable = true;
    userName = "x123";
    userEmail = "x123@users.noreply.github.com";

    delta = {
      enable = true;
      package = pkgs.unstable-small.delta;
      options = {
        navigate = true;
        light = false;
        conflictStyle = "diff3";
        colorMoved = "default";
        syntax-theme = "zenburn";
        side-by-side = false;
      };
    };

    extraConfig = {
      init.defaultBranch = "master";
      push.autoSetupRemote = true;
    };
  };
}
