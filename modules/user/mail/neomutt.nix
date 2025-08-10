{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.user.mail.neomutt.enable = lib.mkEnableOption "neomutt" // {default = false;};
  };

  config = lib.mkIf (config.custom.user.mail.enable && config.custom.user.mail.neomutt.enable) {
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
