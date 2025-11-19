{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.user.desktop.tor-browser = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the tor-browser package.";
      };
    };
  };

  config =
    lib.mkIf
    (
      config.custom.user.desktop.enable
      && config.custom.user.desktop.tor-browser.enable
      && !pkgs.stdenv.isDarwin
    )
    {
      home = {
        packages = [
          pkgs.tor-browser
        ];
      };
    };
}
