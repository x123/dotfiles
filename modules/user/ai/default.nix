{lib, ...}: {
  imports = [
    ./invokeai.nix
    ./ollama.nix
    ./pytorch.nix
  ];

  options.custom.ai.enable = lib.mkEnableOption "enable AI module";
}
