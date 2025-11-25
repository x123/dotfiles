{ pkgs, config, ... }: {
  imports = [ ];

  # support nix flakes
  nix.package = pkgs.nixFlakes;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.settings = {
    trusted-substituters = [
      "https://nixium.boxchop.city"
    ];

    trusted-public-keys = [
      "nixium.boxchop.city-1:I/9SEHdelbS1b8ZX5QeeQKtsugsCcIqCVCec4TZPXIw="
    ];

    auto-optimise-store = true;
    allowed-users = [
      "*"
    ];
    trusted-users = [
      "root"
      "x"
      "fom"
      "@wheel"
    ];
  };

  nix.gc = (if pkgs.stdenv.isDarwin then {
    automatic = true;
    interval = { Weekday = 0; Hour = 0; Minute = 0; };
    options = "--delete-older-than 30d";
  }
  else
    {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    });

}
