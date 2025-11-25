{pkgs, ...}: {
  imports = [];

  console = {
    earlySetup = true;
    font = "${pkgs.powerline-fonts}/share/consolefonts/ter-powerline-v14n.psf.gz";
    packages = with pkgs; [ powerline-fonts];
    colors = [
      "3b4252" # color0#define nord1
      "bf616a" # color1#define nord11
      "a3be8c" # color2#define nord14
      "ebcb8b" # color3#define nord13
      "81a1c1" # color4#define nord9
      "b48ead" # color5#define nord15
      "88c0d0" # color6#define nord8
      "e5e9f0" # color7#define nord5
      "4c566a" # color8#define nord3
      "bf616a" # color9#define nord11
      "a3be8c" # color10#define nord14
      "ebcb8b" # color11#define nord13
      "81a1c1" # color12#define nord9
      "b48ead" # color13#define nord15
      "8fbcbb" # color14#define nord7
      "eceff4" # color15#define nord6
    ];
  };
}

