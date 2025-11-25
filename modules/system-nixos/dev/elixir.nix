{
  config,
  lib,
  pkgs,
  ...
}: {
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

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.dev.enable && config.custom.system-nixos.dev.elixir.enable) {
    environment.systemPackages = [
      pkgs.beam.packages.erlang_25.elixir_1_16
      pkgs.erlang
    ];
  };
}
