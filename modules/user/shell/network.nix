{
  config,
  lib,
  pkgs,
  ...
}: let
  broken_on_darwin = builtins.attrValues {
    inherit
      (pkgs)
      # network
      kubo
      tor
      torsocks
      ;
  };
in {
  options = {
    custom.user.shell.network = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable network tools";
      };
    };
  };

  config = lib.mkIf (config.custom.user.shell.enable && config.custom.user.shell.network.enable) {
    home = {
      packages =
        builtins.attrValues {
          inherit
            (pkgs)
            # net
            aria2
            drill
            sshfs
            # network tools
            dnsutils
            ipcalc
            mtr
            nmap
            ;
        }
        ++ (
          if pkgs.stdenv.isDarwin
          then []
          else broken_on_darwin
        );
    };
  };
}
