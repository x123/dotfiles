{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.desktop.java = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the java package.";
      };
    };
  };

  config =
    lib.mkIf
    (
      config.custom.desktop.enable
      && config.custom.desktop.java.enable
    )
    {
      home = {
        packages = (
          if pkgs.stdenv.isLinux
          then [pkgs.zulu17]
          else []
        );
      };
    };
}
