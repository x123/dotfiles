{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  config = lib.mkIf (config.custom.user.mail.enable && config.custom.mail.neomutt.enable) {
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
