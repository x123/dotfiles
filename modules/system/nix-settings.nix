{pkgs, ...}: {
  imports = [];

  nix = {
    # support nix flakes
    package = pkgs.nixVersions.stable;

    # disable nix-channel
    channel.enable = false;

    settings = {
      experimental-features = ["nix-command" "flakes"];

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
  };

  nix.gc =
    if pkgs.stdenv.isDarwin
    then {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 0;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    }
    else {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
}
