{
  config,
  lib,
  pkgs,
  ...
}:
# let
#   broken_on_darwin = builtins.attrValues {
#     inherit
#       (pkgs)
#       vlc
#       pavucontrol
#       ;
#   };
# in
{
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
          }
          ++ (
            if pkgs.stdenv.isDarwin
            then []
            else []
            # else broken_on_darwin
          );
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
