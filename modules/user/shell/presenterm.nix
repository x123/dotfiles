{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.user.shell.presenterm.enable = lib.mkEnableOption "presenterm presentation tool" // {default = true;};
  };

  config = lib.mkIf config.custom.user.shell.presenterm.enable {
    home = {
      packages = builtins.attrValues {
        inherit
          (pkgs)
          presenterm
          ;
      };
    };
  };
}
