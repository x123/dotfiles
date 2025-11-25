{lib, ...}: {
  imports = [
    ./apparmor.nix
    ./auditd.nix
    ./firejail.nix
  ];

  options = {
    custom.system-nixos.security = {
      auditd.enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable system auditd";
      };
    };
  };
}
