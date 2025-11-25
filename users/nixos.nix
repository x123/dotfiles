{pkgs, ...}: {
  imports = [
    ./modules/common-packages.nix
    ./modules/common-ssh.nix
    ./modules/git.nix
    ./modules/shell.nix
    ./modules/vim.nix
  ];

  home = {
    username = "nixos";
    homeDirectory = "/home/nixos";
    stateVersion = "23.05";
  };

  programs.home-manager.enable = true;

  programs.ssh = {
    matchBlocks = {
      "adamantium" = {
        hostname = "adamantium.boxchop.city";
        user = "root";
        port = 2222;
        identityFile = "/home/nixos/.ssh/id_wslnix";
      };
      "me.github.com" = {
        hostname = "github.com";
        #user = "git";
        port = 22;
        identityFile = "/home/nixos/.ssh/id_wslnix";
      };
    };
  };

  services.gpg-agent = {
    enable = true;

    defaultCacheTtl = 86400;
    defaultCacheTtlSsh = 86400;
    maxCacheTtl = 86400;
    maxCacheTtlSsh = 86400;
    enableSshSupport = true;
    pinentryFlavor = "tty";
    extraConfig = ''
      pinentry-program ${pkgs.pinentry-qt}/bin/pinentry
    '' + ''
      allow-loopback-pinentry
    '';
  };
}
