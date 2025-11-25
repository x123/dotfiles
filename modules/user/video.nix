{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.mypackages.common-packages;
  broken_on_darwin = builtins.attrValues {
    inherit
      (pkgs)
      vlc
      pavucontrol
      ;
  };
in {
  options = {
    mypackages.video = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = ''
          Whether to enable the video packages.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages =
        builtins.attrValues {
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
