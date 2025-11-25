{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  config = lib.mkIf config.custom.mail.enable {
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
  };
}
