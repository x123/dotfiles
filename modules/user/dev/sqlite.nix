{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.user.dev.sqlite.enable = lib.mkEnableOption "SQLite database tools" // {default = true;};
  };

  config = lib.mkIf (config.custom.user.dev.enable && config.custom.user.dev.sqlite.enable) {
    home = {
      packages = builtins.attrValues {
        inherit
          (pkgs)
          sqlite
          ;
      };
    };
  };
}
