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
  };
}
