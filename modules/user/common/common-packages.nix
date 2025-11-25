{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mypackages.common-packages;
  broken_on_darwin = builtins.attrValues {
    inherit
      (pkgs)
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
      
      fd
      usbutils
      whois
      ;
  };
in {
  options = {
    mypackages.common-packages = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = ''
          Whether to enable the common packages.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages =
        builtins.attrValues {
          inherit
            (pkgs)
            # term/shell
            
            file
            fzf
            htop
            hyperfine
            killall
            lsof
            mosh
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
            drill
            sshfs
            # dev
            
            difftastic
            git
            git-crypt
            jq
            nixpkgs-fmt
            yq
            # crypto
            
            age
            gnupg
            rage
            sops
            ssh-to-age
            # archives
            
            unzip
            zip
            # network tools
            
            dnsutils
            ipcalc
            mtr
            nmap
            # passwords
            
            xkcdpass
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
