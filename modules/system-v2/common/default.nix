{lib, ...}: {
  imports = [
    ./console-theme.nix
    ./locale.nix
    ./nix-settings.nix
    ./zsh.nix
  ];

  options = {
    custom.system-v2.common = {
      console-theme.enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable console-theme";
      };
      locale.enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable common locale settings";
      };
      nix-settings.enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable common nix settings";
      };
      zsh.enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable common zsh settings";
      };
    };
  };
}
