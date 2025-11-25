{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.user.common = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable common system configurations";
      };
    };
  };

  config = lib.mkIf config.custom.user.common.enable {
    # report nvd diffs after home-manager switch
    home.activation.report-changes = config.lib.dag.entryAnywhere ''
      ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff $oldGenPath $newGenPath
    '';

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
