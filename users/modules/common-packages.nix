{pkgs, ...}: {
  imports = [];

  home = {
    packages = with pkgs; [
      # term/shell
      file
      htop
      pciutils
      ripgrep
      tmux
      usbutils
      whois

      # net
      aria2

      # dev
      git
      git-crypt
      rocgdb # for strings

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
