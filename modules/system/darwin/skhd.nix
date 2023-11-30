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
	shift + alt - left : yabai -m window --swap west
	shift + alt - down : yabai -m window --swap south
	shift + alt - up : yabai -m window --swap north
	shift + alt - right : yabai -m window --swap east

	# move window
	shift + cmd - left : yabai -m window --warp west
	shift + cmd - down : yabai -m window --warp south
	shift + cmd - up : yabai -m window --warp north
    shift + cmd - right : yabai -m window --warp east

    # float / unfloat window and center on screen
    alt - t : yabai -m window --toggle float; yabai -m window --grid 4:4:1:1:2:2

    # toggle window fullscreen zoom
    alt - f : yabai -m window --toggle zoom-fullscreen

    # toggle window native fullscreen
    shift + alt - f : yabai -m window --toggle native-fullscreen
    '';
  };

}
