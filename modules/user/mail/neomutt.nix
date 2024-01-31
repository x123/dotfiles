{pkgs, ...}: {
  imports = [];

  home = {
    file = {
      neomuttrc = {
        enable = true;
        target = ".config/neomutt/neomuttrc";
        source = ./neomuttrc;
      };
    };

    packages = [
      pkgs.neomutt
    ];
  };
}
