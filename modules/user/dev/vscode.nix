{
  config,
  inputs,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = false;
    profiles.default.extensions = builtins.attrValues {
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
