{
  config,
  lib,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  config = lib.mkIf (cfg.system-darwin.enable) {
    services.karabiner-elements.enable = true;
  };
}
