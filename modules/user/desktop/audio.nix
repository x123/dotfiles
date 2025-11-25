{
  config,
  lib,
  pkgs,
  ...
}: let
  broken_on_darwin = builtins.attrValues {
    # inherit
    #   (pkgs)
    #   youtube-music
    #   ;
  };
in {
  options = {
    custom.desktop.audio = {
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
      config.custom.desktop.enable
      && config.custom.desktop.audio.enable
    )
    {
      home = {
        packages =
          builtins.attrValues
          {
            inherit
              (pkgs)
              bitwig-studio
              ;
          }
          ++ (
            if pkgs.stdenv.isDarwin
            then []
            else broken_on_darwin
          );
      };
    };
}
