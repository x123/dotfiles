{ pkgs, ... }: {
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
          family = "Fira Mono for Powerline";
          style = "Regular";
        };
        bold = {
          family = "Fira Mono for Powerline";
          style = "Bold";
        };
        size = 10;
      };
      window.opacity = 0.9;
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

}
