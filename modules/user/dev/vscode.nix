{
  config,
  inputs,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
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
    };
  };
}
