{
  config,
  lib,
  ...
}: let
  cfg = config.custom.system-nixos;
in {
  options = {
    custom.system-nixos.services.nix-ssh-serve = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "enable nix.sshServe (nix-store over ssh)";
      };
    };
  };

  config = lib.mkIf (cfg.enable && cfg.services.nix-ssh-serve.enable) {
    nix.settings.trusted-users = ["nix-ssh"];
    nix.sshServe = {
      enable = true;
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGXOucJH+GXgiD/ro01zTxFOquY5g3oE6FULjV59Sgz nixpad"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAV4W4TVF5yqOwKFax+b2XtRYbdKy1wy4zFXfFZfv5be xnix"
      ];
      write = true;
    };
  };
}
