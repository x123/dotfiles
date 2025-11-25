{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.user.shell.sec = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable security packages";
      };
    };
  };

  config = lib.mkIf (config.custom.user.shell.enable && config.custom.user.shell.sec.enable) {
    home = {
      packages = builtins.attrValues {
        inherit
          (pkgs)
          ffuf
          netcat-gnu
          urlencode
          ;
        inherit
          (pkgs.unstable-small)
          ip2asn
          ;
        inherit
          (pkgs.python312Packages)
          defang
          ;
      };
    };
  };
}
