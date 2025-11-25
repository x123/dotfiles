{
  config,
  pkgs,
  ...
}: {
  imports = [];

  # report nvd diffs after home-manager switch
  home.activation.report-changes = config.lib.dag.entryAnywhere ''
    ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff $oldGenPath $newGenPath
  '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
