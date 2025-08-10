{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.user.shell.ssh = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable SSH configuration";
      };
    };
  };

  config = lib.mkIf (config.custom.user.shell.enable && config.custom.user.shell.ssh.enable) {
    programs.ssh = {
      enable = true;
      compression = true;
      forwardAgent = false;
      # instead of yes give 52 weeks see Time Formats in man 5 sshd_config
      addKeysToAgent = "52w";
      matchBlocks = {
        "*" = {
          serverAliveInterval = 60;
          extraOptions = {
            ConnectTimeout = "10";
            VisualHostKey = "no";
          };
        };
      };
    };
  };
}
