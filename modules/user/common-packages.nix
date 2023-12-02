{pkgs, ...}: {
  imports = [];

  home = {
    packages = with pkgs; [
      # term/shell
      file
      htop
      killall
      pciutils
      ripgrep
      tree
      usbutils
      whois

      # net
      aria2

      # dev
      git
      git-crypt
      jq
	  rocmPackages.rocgdb
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
      ethtool
      ipcalc
      mtr
      nmap

      # misc
      pinentry

      # system tools
      lm_sensors
      sysstat
    ];
  };
}
