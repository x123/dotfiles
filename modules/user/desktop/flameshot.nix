{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.desktop.flameshot = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the flameshot service.";
      };
    };
  };

  config =
    lib.mkIf
    (
      config.custom.desktop.enable
      && config.custom.desktop.flameshot.enable
      && !pkgs.stdenv.isDarwin
    )
    {
      home = {
        packages =
          builtins.attrValues
          {
            inherit
              (pkgs)
              flameshot
              ;
          };
      };

      services.flameshot = {
        enable = true;
        settings = {
          General = {
            disabledTrayIcon = false;
            showStartupLaunchMessage = true;
            savePath = "${config.xdg.configHome}/flameshot";
          };
        };
      };
    };
}
