{lib, ...}: {
  imports = [
    ./pytorch.nix
    ./invokeai.nix
  ];

  options.custom.ai.enable = lib.mkEnableOption "enable AI module";
}
