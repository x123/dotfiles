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
              fabric-ai
              opencode
              whisper-cpp
              ;
          };
        })
      (lib.mkIf
        (pkgs.stdenv.isDarwin)
        {
          home.packages = builtins.attrValues {
            inherit
              (inputs.nixpkgs-unstable-small.legacyPackages.${system})
              fabric-ai
              opencode
              whisper-cpp
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
