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

      # net
      aria2

      # dev
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
    ];
  };
}
