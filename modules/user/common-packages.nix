{config, pkgs, lib, ...}:
let
  cfg = config.mypackages.common-packages;
  broken_on_darwin = with pkgs; [
    # network
    kubo
    tor
    torsocks

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
    eza
    fd
    usbutils
    whois
  ];

in

with lib;
{
  options = {
    mypackages.common-packages = {
      enable = mkOption {
        default = true;
        type = with types; bool;
        description = ''
          Whether to enable the common packages.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        # term/shell
        file
        htop
        killall
        lsof
        parallel
        pciutils
        ripgrep
        tree

        # hardware info
        inxi

        # media
        imagemagick

        # net
        aria2

        # dev
        difftastic
        git
        git-crypt
        jq
        yq

        # crypto
        age
        gnupg
        sops

        # archives
        unzip
        zip

        # network tools
        dnsutils
        ipcalc
        mtr
        nmap

        # misc
        pinentry
      ] ++ (if pkgs.stdenv.isDarwin then []
      else broken_on_darwin
      );
    };
  };
}
