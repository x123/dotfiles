{pkgs, config, ...}: {
  imports = [];

  # support nix flakes
  nix.package = pkgs.nixFlakes;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.settings.trusted-substituters = ["https://nixium.boxchop.city"];
  nix.settings.trusted-public-keys = ["nixium.boxchop.city:VqGEePxRjPwhVfnLAJBi2duwwkIczIy5ODGW/8KCPbc"];
  nix.settings.auto-optimise-store = true;
  nix.settings.allowed-users = [
    "*"
  ];
  nix.settings.trusted-users = [
    "root"
    "x"
    "@wheel"
  ];
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
