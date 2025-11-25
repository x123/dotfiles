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
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          # instead of yes give 52 weeks see Time Formats in man 5 sshd_config
          addKeysToAgent = "52w";
          compression = true;
          forwardAgent = false;
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
