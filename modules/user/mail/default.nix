{lib, ...}: {
  imports = [
    ./neomutt.nix
  ];
  options.custom.mail.enable = lib.mkEnableOption "enable mail clients";
}
