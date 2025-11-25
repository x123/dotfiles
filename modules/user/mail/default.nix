{lib, ...}: {
  imports = [
    ./neomutt.nix
  ];

  options = {
    custom.user.mail.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable mail configuration.";
    };
  };
}
