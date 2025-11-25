{pkgs, ...}: {
  imports = [];

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
}
