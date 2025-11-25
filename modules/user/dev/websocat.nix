{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.user.dev.websocat.enable = lib.mkEnableOption "websocat WebSocket client" // {default = true;};
  };

  config = lib.mkIf (config.custom.user.dev.enable && config.custom.user.dev.websocat.enable) {
    home = {
      packages = builtins.attrValues {
        inherit
          (pkgs)
          websocat
          ;
      };
    };
  };
}
