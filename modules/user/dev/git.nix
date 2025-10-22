{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.user.dev.git.enable = lib.mkEnableOption "git and related tools" // {default = true;};
  };

  config = lib.mkIf (config.custom.user.dev.enable && config.custom.user.dev.git.enable) {
    home = {
      packages = builtins.attrValues {
        inherit
          (pkgs)
          # dev tools from common
          difftastic
          git
          git-crypt
          jq
          nixpkgs-fmt
          yq
          # existing packages
          github-cli
          gitleaks
          ;
      };
    };

    programs.git = {
      enable = true;
      settings = {
        user.email = "x123";
        user.name = "x123@users.noreply.github.com";
        init.defaultBranch = "master";
        push.autoSetupRemote = true;
      };

      delta = {
        enable = true;
        options = {
          navigate = true;
          light = false;
          conflictStyle = "diff3";
          colorMoved = "default";
          syntax-theme = "zenburn";
          side-by-side = false;
        };
      };
    };
  };
}
