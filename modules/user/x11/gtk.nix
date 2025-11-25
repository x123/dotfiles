{ pkgs, inputs, config, system, ... }: {
  imports = [ ];

  gtk = {
    enable = true;
    font.name = "Noto Sans";
    font.size = 10;
    theme = {
      package = pkgs.nordic;
      name = "Nordic";
      #name = "breeze-dark";
      #package = pkgs.breeze-gtk;
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
      #gtk-cursor-theme-name = breeze_cursors
      #gtk-cursor-theme-size=24
      #gtk-icon-theme-name="breeze-dark";
      #gtk-modules="colorreload-gtk-module";
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-primary-button-warps-slider = false;
      gtk-toolbar-style = 3;
      gtk-decoration-layout = "icon:minimize,maximize,close";
      gtk-enable-animations = true;
      #gtk-cursor-theme-name = breeze_cursors
      #gtk-cursor-theme-size=24
      #gtk-icon-theme-name="breeze-dark";
      #gtk-modules="colorreload-gtk-module";
    };
  };

}
