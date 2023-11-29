{pkgs, ...}: {
  imports = [];

  programs.git = {
    enable = true;
    userName = "x123";
    userEmail = "x123@users.noreply.github.com";
    extraConfig.push.autoSetupRemote = true; #push.autoSetupRemote true

  };
}
