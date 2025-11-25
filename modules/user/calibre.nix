{pkgs, ...}: {
  imports = [];

  home = {
    packages = with pkgs; [
      calibre
      libmtp
    ];
  };
}
