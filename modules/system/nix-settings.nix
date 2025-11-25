{pkgs, config, ...}: {
  imports = [];

  # support nix flakes
  nix.package = pkgs.nixFlakes;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = (if pkgs.stdenv.isDarwin then {
    automatic = true;
    interval = { Weekday = 0; Hour = 0; Minute = 0;};
    options = "--delete-older-than 30d";
  }
  else
  {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  });
}
