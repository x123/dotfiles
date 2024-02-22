{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.desktop.obs-studio = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the obs-studio packages.";
      };
    };
  };

  config =
    lib.mkIf
    (
      config.custom.desktop.enable
      && config.custom.desktop.obs-studio.enable
    )
    {
      programs = {
        obs-studio = {
          enable = true;
          plugins = [
            pkgs.obs-studio-plugins.input-overlay
            # pkgs.obs-studio-plugins.obs-nvfbc
            pkgs.obs-studio-plugins.obs-pipewire-audio-capture
            pkgs.obs-studio-plugins.obs-vkcapture
          ];
        };
      };
    };
}
