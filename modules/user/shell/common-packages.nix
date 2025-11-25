{
  config,
  lib,
  pkgs,
  ...
}: let
  broken_on_darwin = builtins.attrValues {
    inherit
      (pkgs)
      # system tools
      bashmount
      ethtool
      inotify-tools
      lm_sensors
      strace
      sysstat
      # hardware info
      dmidecode
      # term/shell
      fd
      usbutils
      whois
      ;
  };
in {
  options = {
    custom.user.shell.common-packages = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable common shell packages";
      };
    };
  };

  config = lib.mkIf (config.custom.user.shell.enable && config.custom.user.shell.common-packages.enable) {
    home = {
      packages =
        builtins.attrValues {
          inherit
            (pkgs)
            # existing packages
            bc
            cpulimit
            coreutils-full
            dnsdbq
            file
            htop
            pciutils
            ripgrep
            visidata
            # new shell tools from common
            fzf
            hyperfine
            killall
            lsof
            parallel
            tree
            # hardware info
            inxi
            # media
            imagemagick
            # archives
            unzip
            zip
            # passwords
            phraze
            ;
          inherit
            (pkgs.unixtools)
            watch
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
