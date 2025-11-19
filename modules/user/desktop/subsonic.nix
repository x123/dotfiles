{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.user.desktop.subsonic = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable a subsonic client.";
      };
    };
  };

  config =
    lib.mkIf
    (
      config.custom.user.desktop.enable
      && config.custom.user.desktop.subsonic.enable
      && !pkgs.stdenv.isDarwin
    )
    {
      home = {
        packages =
          builtins.attrValues
          {
            inherit
              (pkgs)
              # feishin
              supersonic
              # termsonic
              ;
          };
      };
    };
}
