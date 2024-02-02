{
  config,
  lib,
  pkgs,
  ...
}: let
  broken_on_darwin = builtins.attrValues {
    inherit
      (pkgs)
      vlc
      pavucontrol
      ;
  };
in {
  options = {
    custom.desktop.video = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the video packages.";
      };
    };
  };

  config =
    lib.mkIf
    (
      config.custom.desktop.enable
      && config.custom.desktop.video.enable
    )
    {
      home = {
        packages =
          builtins.attrValues
          {
            inherit
              (pkgs)
              aria2
              streamlink
              ;
          }
          ++ (
            if pkgs.stdenv.isDarwin
            then []
            else broken_on_darwin
          );
      };

      programs.yt-dlp = {
        enable = true;
        settings = {
          embed-thumbnail = true;
          embed-subs = true;
          sub-langs = "all";
          downloader = "aria2c";
          downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
        };
      };
    };
}
