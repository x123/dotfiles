{pkgs, ...}: {
  imports = [];

  services.skhd = {
    enable = true;
    skhdConfig = ''
    # open terminal
    alt - return : /Users/fom/Applications/Home\ Manager\ Apps/Alacritty.app/Contents/MacOS/alacritty

    # focus window
    alt - left : yabai -m window --focus west
    alt - down : yabai -m window --focus south
    alt - up : yabai -m window --focus north
    alt - right : yabai -m window --focus east

    # swap window
    shift + cmd - left : yabai -m window --swap west
    shift + cmd - down : yabai -m window --swap south
    shift + cmd - up : yabai -m window --swap north
    shift + cmd - right : yabai -m window --swap east

    # move window
    shift + alt - left : yabai -m window --warp west
    shift + alt - down : yabai -m window --warp south
    shift + alt - up : yabai -m window --warp north
    shift + alt - right : yabai -m window --warp east

    alt - v : yabai -m window --insert south
    alt - h : yabai -m window --insert east

    shift + alt - c : launchctl kickstart -k "gui/''${UID}/org.nixos.yabai" && launchctl kickstart -k "gui/''${UID}/org.nixos.skhd"

    # float / unfloat window and center on screen
    alt - t : yabai -m window --toggle float; yabai -m window --grid 4:4:1:1:2:2

    # toggle window fullscreen zoom
    alt - f : yabai -m window --toggle zoom-fullscreen

    # toggle window native fullscreen
    shift + alt - f : yabai -m window --toggle native-fullscreen

    # fast focus desktop
    # cmd + alt - x : yabai -m space --focus recent
    #cmd + alt - left : yabai -m space --focus prev
    #cmd + alt - right : yabai -m space --focus next

    # focus monitor
    cmd + alt - x  : yabai -m display --focus recent
    cmd + alt - z  : yabai -m display --focus prev
    cmd + alt - c  : yabai -m display --focus next
    cmd + alt - 1  : yabai -m display --focus 1
    cmd + alt - 2  : yabai -m display --focus 2
    cmd + alt - 3  : yabai -m display --focus 3

    # send window to monitor and follow focus
    ctrl + cmd - x  : yabai -m window --display recent; yabai -m display --focus recent
    ctrl + cmd - z  : yabai -m window --display prev; yabai -m display --focus prev
    ctrl + cmd - c  : yabai -m window --display next; yabai -m display --focus next
    ctrl + cmd - 1  : yabai -m window --display 1; yabai -m display --focus 1
    ctrl + cmd - 2  : yabai -m window --display 2; yabai -m display --focus 2
    ctrl + cmd - 3  : yabai -m window --display 3; yabai -m display --focus 3
    '';
  };

}
