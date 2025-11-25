{pkgs, ...}: {
  imports = [];

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
      merge.ff = false;
      pull.ff = true;
    };

  };
}
