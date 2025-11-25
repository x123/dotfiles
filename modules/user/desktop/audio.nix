{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.user.desktop.audio = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the audio packages.";
      };
    };
  };

  config =
    lib.mkIf
    (
      config.custom.user.desktop.enable
      && config.custom.user.desktop.audio.enable
    )
    {
      home = {
        packages =
          builtins.attrValues
          {
            inherit
              (pkgs)
              audacity
              bitwig-studio
              ;
          };
      };
    };
}
