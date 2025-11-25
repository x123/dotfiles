{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options.custom.desktop.discord.enable = lib.mkEnableOption "discord";

  config =
    lib.mkIf
    (
      config.custom.desktop.enable
      && config.custom.desktop.discord.enable
    )
    {
      # nixpkgs.overlays = [
      #   (
      #     final: prev: {
      #       discord = prev.discord.overrideAttrs (
      #         _: {
      #           src = builtins.fetchTarball {
      #             url = "https://discord.com/api/download?platform=linux&format=tar.gz";
      #             sha256 = "sha256:1xjk77g9lj5b78c1w3fj42by9b483pkbfb41yzxrg4p36mnd2hkn";
      #           };
      #         }
      #       );
      #     }
      #   )
      # ];

      home = {
        file = {
          firejail-Discord-profile = {
            enable = true;
            text = ''
              include ${pkgs.firejail}/etc/firejail/Discord.profile
              blacklist ${pkgs.nixVersions.stable}/bin/*
              noblacklist ''${HOME}/.nix-profile/share/themes
              # blacklist ''${HOME}/.nix-profile/bin/*
              blacklist ''${HOME}/.nix-profile/etc/*
              blacklist ''${HOME}/.nix-profile/example/*
              blacklist ''${HOME}/.nix-profile/include/*
              # blacklist ''${HOME}/.nix-profile/lib/*
              blacklist ''${HOME}/.nix-profile/libexec/*
              blacklist ''${HOME}/.nix-profile/manifest.nix
              # blacklist ''${HOME}/.nix-profile/opt/*
              blacklist ''${HOME}/.nix-profile/rplugin.vim
              blacklist ''${HOME}/.nix-profile/sbin/*
              blacklist ''${HOME}/.nix-profile/share/*
              blacklist ''${HOME}/.nix-profile/XyGrib/*
              blacklist ''${HOME}/.nix-profile/yed/*
            '';
            target = ".config/firejail/Discord.profile";
          };
        };

        packages = [
          pkgs.discord
        ];
      };
    };
}
