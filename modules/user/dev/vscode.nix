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
          # home.packages = builtins.attrValues {
          #   inherit
          #     (inputs.nixpkgs-unstable-small.legacyPackages.${system})
          #     aider-chat-full
          #     ;
          #   inherit
          #     (pkgs)
          #     claude-code
          #     ;
          # };
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
          # home.packages = builtins.attrValues {
          #   inherit
          #     (inputs.nixpkgs-unstable-small.legacyPackages.${system})
          #     aider-chat
          #     ;
          # };
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
