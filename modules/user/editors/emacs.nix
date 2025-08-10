{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options.custom.editors.emacs.enable = lib.mkEnableOption "emacs";

  config = lib.mkIf (config.custom.user.editors.enable && config.custom.editors.emacs.enable) {
    # home.file.".emacs.d" = {
    #   recursive = true;
    #   source = pkgs.fetchFromGitHub {
    #     owner = "syl20bnr";
    #     repo = "spacemacs";
    #     rev = "develop";
    #     sha256 = "sha256-a3EkS4tY+VXWqm61PmLnF0Zt94VAsoe5NmubaLPNxhE=";
    #   };
    # };
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-nox;
    };
  };
}
