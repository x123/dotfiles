{pkgs, ...}: {
  imports = [
    ./i3-config.nix
    ./redshift.nix
  ];

  home = {
    packages = with pkgs; [
      # term/shell
      #file
    ];

  };

}
