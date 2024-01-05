{ pkgs, inputs, config, system, ... }: {
  imports = [ ];

  home = {
    file.ghostty-conf = {
      target = "${config.xdg.configHome}/ghostty/config";
      source = ./files/ghostty.conf;
#      text = ''
#        # The syntax is "key = value". The whitespace around the equals doesn't matter.
#        theme = nord
#
#        mouse-hide-while-typing = true
#        mouse-shift-capture = true
#        cursor-click-to-move = false
#        copy-on-select = clipboard
#
#        background-opacity = 0.9
#        background-blur-radius = 4
#
#        window-theme = "dark"
#        gtk-adwaita = true
#        window-decoration = false
#        gtk-titlebar = false
#        confirm-close-surface = false
#
#        font-size = 12
#        #font-family = "Inconsolata LGC"
#        #font-style = "Regular"
#        #font-family-bold = "Inconsolata LGC"
#        #font-style-bold = "Bold"
#
#        # Blank lines are ignored!
#
#        keybind = ctrl+z=close_surface
#        keybind = ctrl+d=new_split:right
#      '';
    };
    packages = [
      inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };

}
