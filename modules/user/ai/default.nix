{lib, ...}: {
  imports = [
    ./ollama.nix
    ./pytorch.nix
  ];

  options.custom.user.ai.enable = lib.mkEnableOption "enable AI module";
}
