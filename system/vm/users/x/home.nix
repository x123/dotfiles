{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../../../../modules/user
  ];

  # sops = {
  #   age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  #   defaultSopsFile = ./secrets.yaml;
  # };

  custom = {
    desktop = {
      enable = true;

      discord.enable = false;
      flameshot.enable = true;
      ghostty.enable = true;
      inkscape.enable = false;
      obs-studio.enable = false;
      slack.enable = false;
      telegram.enable = true;
      tor-browser.enable = false;
      video.enable = true;

      blender = {
        enable = false;
        cudaSupport = false;
      };

      i3status-rust = {
        # temperature = {
        #   enable = true;
        #   chip = "nct6686-isa-0a20";
        #   inputs = ["AMD TSI Addr 98h"];
        # };
        nvidia.enable = false;
      };
    };

    games.enable = false;

    user = {
      ai = {
        enable = false;

        ollama.enable = false;
        pytorch.enable = false;
      };

      editors = {
        emacs.enable = false;
        helix.enable = false;
        neovim.enable = true;
        vim.enable = false;
        vscode.enable = false;
      };

      mail.enable = false;
    };
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
        identityFile = "/home/x/.ssh/id_vm";
        identitiesOnly = true;
      };
      "github.com" = {
        hostname = "github.com";
        port = 22;
        identityFile = "/home/x/.ssh/id_vm";
        identitiesOnly = true;
      };
      "hetznix" = {
        hostname = "hetznix.nixlink.net";
        port = 22;
        user = "root";
        identityFile = "/home/x/.ssh/id_vm";
        identitiesOnly = true;
      };
      "hetznix.nixlink.net" = {
        hostname = "hetznix.nixlink.net";
        port = 22;
        user = "root";
        identityFile = "/home/x/.ssh/id_vm";
        identitiesOnly = true;
      };
    };
  };
}
