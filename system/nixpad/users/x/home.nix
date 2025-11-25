{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../../../../modules/user
    # ./local/borgmatic.nix
  ];

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
  };

  custom = {
    desktop = {
      enable = true;

      audio.enable = false; # this is just youtube-music right now
      blender.enable = false;
      discord.enable = true;
      flameshot.enable = true;
      ghostty.enable = true;
      i3status-rust = {
        battery.enable = true;
        temperature = {
          enable = true;
          chip = "thinkpad-isa-0000";
          inputs = ["CPU"];
        };
      };
      keepassxc.enable = true;
      obs-studio.enable = false;
      slack.enable = false;
      video.enable = true;
    };

    ai = {
      enable = false;

      ollama.enable = true;
      pytorch.enable = false;
    };

    editors = {
      helix.enable = false;
      neovim.enable = true;
      vim.enable = false;
    };

    games.enable = false;
    laptop.enable = true;
    mail.enable = true;
  };

  home = {
    username = "x";
    homeDirectory = "/home/x";
    stateVersion = "24.05";
    sessionPath = [
      "$HOME/bin"
    ];
  };

  programs.ssh = {
    matchBlocks = {
      "me.github.com" = {
        hostname = "github.com";
        port = 22;
        identityFile = "/home/x/.ssh/id_nixpad";
        identitiesOnly = true;
      };
      "github.com" = {
        hostname = "github.com";
        port = 22;
        identityFile = "/home/x/.ssh/id_nixpad";
        identitiesOnly = true;
      };
      "xnix" = {
        hostname = "xnix.lan";
        port = 22;
        user = "x";
        identityFile = "/home/x/.ssh/id_nixpad";
        identitiesOnly = true;
      };
      "xnix.lan" = {
        hostname = "xnix.lan";
        port = 22;
        user = "x";
        identityFile = "/home/x/.ssh/id_nixpad";
        identitiesOnly = true;
      };
      "hetznix" = {
        hostname = "hetznix.boxchop.city";
        port = 22;
        user = "root";
        identityFile = "/home/x/.ssh/id_nixpad";
        identitiesOnly = true;
      };
      "hetznix.boxchop.city" = {
        hostname = "hetznix.boxchop.city";
        port = 22;
        user = "root";
        identityFile = "/home/x/.ssh/id_nixpad";
        identitiesOnly = true;
      };
    };
  };
}
