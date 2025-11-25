{
  lib,
  pkgs,
  ...
}: {
  imports = [];

  environment.systemPackages = [
    pkgs.nh
    pkgs.nix-output-monitor
    pkgs.nix-tree
  ];

  # show nvd diffs after (nixos|darwin)-rebuild switch
  system.activationScripts.nvd =
    {
      text = ''
        ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff \
            /run/current-system "$systemConfig"
      '';
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux {
      supportsDryActivation = true;
    };

  nix = {
    # support nix flakes
    package = pkgs.nixVersions.stable;

    optimise.automatic = true;
    settings = {
      download-buffer-size = 524288000;
      experimental-features = ["nix-command" "flakes"];
      allowed-users = ["*"];
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
