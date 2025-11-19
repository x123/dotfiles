{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.user.desktop.obs-studio = {
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
      config.custom.user.desktop.enable
      && config.custom.user.desktop.obs-studio.enable
    )
    {
      programs = {
        obs-studio = {
          enable = true;
          plugins = [
            pkgs.obs-studio-plugins.input-overlay
            # pkgs.obs-studio-plugins.obs-nvfbc  # nvidia framebuffer capture, only for linux
            pkgs.obs-studio-plugins.obs-pipewire-audio-capture
            pkgs.obs-studio-plugins.obs-vkcapture
          ];
        };
      };
    };
}
