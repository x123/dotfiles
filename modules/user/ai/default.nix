{lib, ...}: {
  imports = [
    ./ollama.nix
    ./pytorch.nix
  ];

  options.custom.ai.enable = lib.mkEnableOption "enable AI module";
}
