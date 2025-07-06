{
  config,
  inputs,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default.extensions = builtins.attrValues {
      inherit
        (pkgs.vscode-extensions.rooveterinaryinc)
        roo-cline
        ;
      inherit
        (pkgs.vscode-extensions.vscodevim)
        vim
        ;
      inherit
        (pkgs.vscode-extensions.github)
        copilot
        copilot-chat
        ;
      inherit
        (pkgs.vscode-extensions.davidanson)
        vscode-markdownlint
        ;
    };
  };
}
