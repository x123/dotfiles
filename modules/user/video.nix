{config, pkgs, lib, inputs, ...}:
let
  cfg = config.mypackages.common-packages;
  broken_on_darwin = with pkgs; [
    vlc
    pavucontrol
  ];

in

with lib;
{
  options = {
    mypackages.video = {
      enable = mkOption {
        default = true;
        type = with types; bool;
        description = ''
          Whether to enable the video packages.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
      aria2
      streamlink
      ] ++ (if pkgs.stdenv.isDarwin then []
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
