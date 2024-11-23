{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../../../../modules/user
    ./local/borgmatic.nix
    ./local/btop.nix
    ./local/poe.nix
  ];

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
  };

  custom = {
    desktop = {
      enable = true;

      audio.enable = true; # this is just youtube-music right now
      discord.enable = true;
      dropbox.enable = true;
      flameshot.enable = false;
      ghostty.enable = true;
      inkscape.enable = true;
      keepassxc.enable = true;
      keybase.enable = true;
      obs-studio.enable = false;
      slack.enable = true;
      telegram.enable = true;
      tor-browser.enable = true;
      video.enable = true;

      wayland = {
        enable = false;
        hyprland.enable = false;
        sway.enable = false;
      };

      x11 = {
        enable = true;
        i3.enable = true;
      };

      blender = {
        enable = false;
        cudaSupport = true;
      };

      i3status-rust = {
        temperature = {
          enable = true;
          chip = "nct6686-isa-0a20";
          inputs = ["AMD TSI Addr 98h"];
        };
        nvidia.enable = true;
      };
    };

    ai = {
      enable = false;

      ollama.enable = true;
      pytorch.enable = false;
    };

    editors = {
      helix.enable = true;
      neovim.enable = true;
      vim.enable = false;
    };

    games.enable = true;
    mail.enable = true;
  };

  home = {
    username = "x";
    homeDirectory = "/home/x";
    stateVersion = "23.05";
    sessionPath = [
      "$HOME/bin"
    ];
  };

  programs.ssh = {
    matchBlocks = {
      "me.github.com" = {
        hostname = "github.com";
        port = 22;
        identityFile = "/home/x/.ssh/id_xbox";
        identitiesOnly = true;
      };
      "github.com" = {
        hostname = "github.com";
        port = 22;
        identityFile = "/home/x/.ssh/id_xbox";
        identitiesOnly = true;
      };
      "hetznix" = {
        hostname = "hetznix.boxchop.city";
        port = 22;
        user = "root";
        identityFile = "/home/x/.ssh/id_xnix";
        identitiesOnly = true;
      };
      "hetznix.boxchop.city" = {
        hostname = "hetznix.boxchop.city";
        port = 22;
        user = "root";
        identityFile = "/home/x/.ssh/id_xnix";
        identitiesOnly = true;
      };
    };
  };
}
