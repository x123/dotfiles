{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.editors.vscode.enable = lib.mkEnableOption "VSCode editor and extensions" // {default = true;};
  };

  config = lib.mkIf (config.custom.user.editors.enable && config.custom.editors.vscode.enable) (
    lib.mkMerge
    [
      (lib.mkIf
        (pkgs.stdenv.isLinux)
        {
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
          home.packages = builtins.attrValues {
            # inherit
            #   (inputs.nixpkgs-unstable-small.legacyPackages.${system})
            #   aider-chat-full
            #   ;
            inherit
              (pkgs)
              nodejs_24
              ;
          };
        })
      (lib.mkIf
        (pkgs.stdenv.isDarwin)
        {
          programs.vscode = {
            enable = true;
            package = pkgs.vscode;
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
          home.packages = builtins.attrValues {
            inherit
              (pkgs)
              nodejs_20
              ;
          };
        })
    ]
  );
}
