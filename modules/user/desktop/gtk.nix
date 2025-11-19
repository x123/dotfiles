{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  config = lib.mkIf (config.custom.user.desktop.enable && !pkgs.stdenv.isDarwin) {
    gtk = {
      enable = true;
      font.name = "Noto Sans";
      font.size = 10;
      theme = {
        package = pkgs.nordic;
        name = "Nordic";
      };
      gtk2.extraConfig = ''
        gtk-toolbar-style=3
      '';
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-primary-button-warps-slider = false;
        gtk-toolbar-style = 3;
        gtk-decoration-layout = "icon:minimize,maximize,close";
        gtk-enable-animations = true;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-primary-button-warps-slider = false;
        gtk-toolbar-style = 3;
        gtk-decoration-layout = "icon:minimize,maximize,close";
        gtk-enable-animations = true;
      };
    };
  };
}
