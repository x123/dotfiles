{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options = {
    custom.system-nixos.steam.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "Whether to enable system steam";
    };
  };

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.steam.enable) {
    programs.steam = {
      enable = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };
  };
}
