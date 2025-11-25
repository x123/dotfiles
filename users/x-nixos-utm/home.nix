{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../modules/user/alacritty
    ../../modules/user/common-packages.nix
    ../../modules/user/common-ssh.nix
    ../../modules/user/firefox.nix
    ../../modules/user/git.nix
    ../../modules/user/gpg-agent.nix
    ../../modules/user/keepass.nix
    ../../modules/user/shell
    #../../modules/user/tor-browser.nix
    #../../modules/user/video.nix
    ../../modules/user/vim.nix
    ../../modules/user/x11
  ];

  # force rofi font size for hidpi
  programs.rofi = lib.mkForce {
    enable = true;
    font = "Fira Mono for Powerline 20";
    theme = "${pkgs.rofi}/share/rofi/themes/Arc-Dark.rasi";
    terminal = "${pkgs.alacritty}/bin/alacritty";
    extraConfig = {
      modes = "window,drun,ssh,run,combi";
      combi-modes = "window,ssh,drun,run";
    };
  };

  # force alacritty font size for hidpi
  programs.alacritty = lib.mkForce {
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
        size = 20;
        draw_bold_text_with_bright_colors = true;
      };
      window.opacity = 0.9;
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  home = {
    username = "x";
    homeDirectory = "/home/x";
    stateVersion = "23.05";
  };
  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # net
    persepolis

    # office
    libreoffice

    # art
    gimp

    # misc
    xygrib
  ];

  programs.ssh = {
    matchBlocks = {
      "adamantium" = {
        hostname = "adamantium.boxchop.city";
        user = "root";
        port = 2222;
        identityFile = "/home/x/.ssh/id_fom-mba-utm-vm";
      };
      "me.github.com" = {
        hostname = "github.com";
        port = 22;
        identityFile = "/home/x/.ssh/id_fom-mba-utm-vm";
      };
    };
  };

}
