{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./themes/nord.nix
  ];

  config = lib.mkIf config.custom.user.desktop.enable {
    home.packages = [
      pkgs.alacritty
    ];

    programs.alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
        font = {
          normal = {
            family = "CodeNewRoman Nerd Font";
            style = "Regular";
          };
          bold = {
            family = "CodeNewRoman Nerd Font";
            style = "Bold";
          };
          size = 12;
        };
        window.opacity = 0.9;
        scrolling.multiplier = 5;
        selection.save_to_clipboard = true;
      };
    };
  };
}
