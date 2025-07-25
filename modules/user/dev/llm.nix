{
  inputs,
  lib,
  pkgs,
  system,
  ...
}: {
  imports = [];

  config =
    lib.mkMerge
    [
      (lib.mkIf
        (!pkgs.stdenv.isDarwin)
        {
          home.packages = builtins.attrValues {
            inherit
              (inputs.nixpkgs-unstable-small.legacyPackages.${system})
              aider-chat-full
              ;
            inherit
              (pkgs)
              claude-code
              ;
          };
        })
      (lib.mkIf
        (pkgs.stdenv.isDarwin)
        {
          home.packages = builtins.attrValues {
            inherit
              (inputs.nixpkgs-unstable-small.legacyPackages.${system})
              aider-chat
              ;
          };
        })
    ];

  # home = {
  #   packages = builtins.attrValues {
  #     inherit
  #       (inputs.nixpkgs-unstable-small.legacyPackages.${system})
  #       aider-chat-full
  #       ;
  #   };
  # };
}
