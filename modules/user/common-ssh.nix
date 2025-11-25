{pkgs, ...}: {
  imports = [];

  programs.ssh = {
    enable = true;
    compression = true;
    forwardAgent = false;
    addKeysToAgent = "yes";

    matchBlocks = {
      "*" = {
        serverAliveInterval = 60;
        extraOptions = {
          ConnectTimeout = "10";
        };
      };
    };
  };

}
