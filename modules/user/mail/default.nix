{lib, ...}: {
  imports = [
    ./neomutt.nix
  ];

  options = {
    custom.user.mail.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable mail configuration.";
    };

    custom.mail.neomutt.enable = lib.mkEnableOption "neomutt mail client";
  };
}
