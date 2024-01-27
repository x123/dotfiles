{
  pkgs,
  inputs,
  ...
}: {
  imports = [];

  home = {
    file = {
      neomuttrc = {
        enable = true;
        target = ".config/neomutt/neomuttrc";
        source = ./files/neomuttrc;
      };
    };

    packages = with pkgs; [
      neomutt
    ];
  };
}
