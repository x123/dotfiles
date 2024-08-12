{pkgs, ...}: {
  imports = [];

  programs.btop = {
    enable = true;
    settings = {
      # https://github.com/aristocratos/btop#configurability
      color_theme = "nord";
      theme_background = true;
      update_ms = 200;
    };
  };
}
