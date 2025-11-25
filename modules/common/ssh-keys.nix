{lib, ...}: {
  options.custom.common.sshKeys = {
    enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "Enable shared SSH key definitions";
    };

    adminKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAV4W4TVF5yqOwKFax+b2XtRYbdKy1wy4zFXfFZfv5be xnix"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID6elYl8CWSR32Zx33D+XgQWM/721sDmnyFJec7vDeMb fom-mba"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMXxyU8SafRkTGJ3ZGMlsl9iXu7Yb+IT2R2OHg0KVx+E fom-mbp"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGXOucJH+GXgiD/ro01zTxFOquY5g3oE6FULjV59Sgz nixpad"
      ];
      description = "Administrative SSH keys for system access";
    };
  };

  config = {
    # No automatic configuration - keys provided via options only
  };
}
