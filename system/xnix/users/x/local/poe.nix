{
  lib,
  pkgs,
  ...
}: {
  home.file = {
    xbindkeysrc = {
      enable = true;
      target = ".xbindkeysrc";
      text = ''
        "${pkgs.xdotool}/bin/xdotool key --delay 0 --window $( ${pkgs.xdotool}/bin/xdotool search --name Path ) Return slash e x i t Return"
          m:0x0 + c:49
      '';
    };
  };
}
