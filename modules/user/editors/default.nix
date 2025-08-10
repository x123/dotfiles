{
  config,
  lib,
  ...
}: {
  imports = [
    ./emacs.nix
    ./helix.nix
    ./neovim.nix
    ./vim.nix
  ];

  options.custom.user.editors.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable editor configurations";
  };
}
