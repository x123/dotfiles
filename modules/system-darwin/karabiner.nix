{
  config,
  lib,
  ...
}: {
  imports = [];
  options = {
    custom.system-darwin.karabiner.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether to enable karabiner on darwin";
    };
  };

  config = lib.mkIf (config.custom.system-darwin.enable && config.custom.system-darwin.karabiner.enable) {
    services.karabiner-elements.enable = true;
  };
}
