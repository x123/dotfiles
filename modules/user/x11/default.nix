{pkgs, ...}: {
  imports = [
    ./i3-config.nix
  ];

  home = {
    packages = with pkgs; [
      # term/shell
      #file
    ];

  };

}
