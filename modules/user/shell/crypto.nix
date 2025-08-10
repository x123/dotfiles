{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.user.shell.crypto = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable crypto tools and GPG agent";
      };
    };
  };

  config = lib.mkIf (config.custom.user.shell.enable && config.custom.user.shell.crypto.enable) {
    home = {
      packages = builtins.attrValues {
        inherit
          (pkgs)
          # crypto
          age
          gnupg
          rage
          sops
          ssh-to-age
          ;
      };
    };

    services.gpg-agent = {
      enable =
        if pkgs.stdenv.isDarwin
        then false
        else true;

      defaultCacheTtl = 31536000;
      defaultCacheTtlSsh = 31536000;
      maxCacheTtl = 31536000;
      maxCacheTtlSsh = 31536000;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-tty;
      extraConfig =
        ''
          pinentry-program ${pkgs.pinentry-qt}/bin/pinentry
        ''
        + ''
          allow-loopback-pinentry
        '';
    };

    programs.ssh = {
      extraConfig =
        if pkgs.stdenv.isDarwin
        then ''''
        else ''
          Match host * exec "gpg-connect-agent UPDATESTARTUPTTY /bye"
        '';
    };
  };
}
