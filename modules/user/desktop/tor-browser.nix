{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.desktop.tor-browser = {
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
      config.custom.desktop.enable
      && config.custom.desktop.tor-browser.enable
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
