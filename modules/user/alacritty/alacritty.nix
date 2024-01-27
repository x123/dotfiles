{pkgs, ...}: {
  imports = [
    ./themes/nord.nix
  ];

  home.packages = with pkgs; [
    alacritty
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
}
