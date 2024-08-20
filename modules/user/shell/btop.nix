{pkgs, ...}: {
  imports = [];

  programs.btop = {
    enable = true;
    settings = {
      # https://github.com/aristocratos/btop#configurability
      color_theme = "nord";
      theme_background = false;
      update_ms = 200;
      vim_keys = true;
    };
  };
}
