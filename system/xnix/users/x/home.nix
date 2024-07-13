{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../../../../modules/user
    ./local/borgmatic.nix
  ];

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
  };

  custom = {
    desktop = {
      enable = true;

      audio.enable = true;
      blender.enable = true;
      discord.enable = true;
      flameshot.enable = true;
      ghostty.enable = true;
      i3status-rust = {
        temperature = {
          enable = true;
          chip = "nct6686-isa-0a20";
          inputs = ["AMD TSI Addr 98h"];
        };
        nvidia.enable = true;
      };
      obs-studio.enable = true;
      slack.enable = true;
      video.enable = true;
    };

    ai = {
      enable = false;

      invokeai.enable = false;
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
      "nixium" = {
        hostname = "nixium.boxchop.city";
        port = 22;
        user = "root";
        identityFile = "/home/x/.ssh/id_xnix";
        identitiesOnly = true;
        checkHostIP = false;
        extraOptions = {
          StrictHostKeyChecking = "no";
        };
      };
      "nixium.boxchop.city" = {
        hostname = "nixium.boxchop.city";
        port = 22;
        user = "root";
        identityFile = "/home/x/.ssh/id_xnix";
        identitiesOnly = true;
        checkHostIP = false;
        extraOptions = {
          StrictHostKeyChecking = "no";
        };
      };
    };
  };
}
