{lib, ...}: {
  imports = [
    ./console-theme.nix
    ./filesystems.nix
    ./locale.nix
    ./zsh.nix
  ];

  options = {
    custom.system-nixos.common = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable the system-nixos.common modules";
      };
    };
  };
}
