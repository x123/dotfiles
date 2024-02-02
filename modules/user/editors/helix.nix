{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options.custom.editors.helix.enable = lib.mkEnableOption "helix";

  config = lib.mkIf config.custom.editors.helix.enable {
    home = {
      packages = [
        pkgs.helix
      ];
    };

    programs.helix = {
      enable = true;
      defaultEditor = false;
      settings = {
        theme = "nord";
        editor = {
          line-number = "relative";
          lsp.display-messages = true;
        };
      };
    };
  };
}
