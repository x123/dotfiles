{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom;
in {
  imports = [];

  options = {
    custom.system-nixos.dev.elixir = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the system dev binaries";
      };
    };
  };

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.dev.elixir.enable) {
    environment.systemPackages = [
      pkgs.beam.packages.erlang_25.elixir_1_16
      pkgs.erlang
    ];
  };
}
