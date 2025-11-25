{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config =
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
    ];

  # programs.vscode = {
  #   enable = true;
  #   package = pkgs.vscodium;
  #   profiles.default.extensions = builtins.attrValues {
  #     inherit
  #       (pkgs.vscode-extensions.rooveterinaryinc)
  #       roo-cline
  #       ;
  #     inherit
  #       (pkgs.vscode-extensions.vscodevim)
  #       vim
  #       ;
  #     inherit
  #       (pkgs.vscode-extensions.github)
  #       copilot
  #       copilot-chat
  #       ;
  #     inherit
  #       (pkgs.vscode-extensions.davidanson)
  #       vscode-markdownlint
  #       ;
  #   };
  # };
}
