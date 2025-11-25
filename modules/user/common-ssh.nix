{pkgs, ...}: {
  imports = [];

  programs.ssh = {
    enable = true;
    compression = true;
    forwardAgent = false;

    matchBlocks = {
      "*" = {
        serverAliveInterval = 60;
        extraOptions = {
          ConnectTimeout = "10";
        };
      };
    };

    extraConfig = ''
      AddKeysToAgent yes
    '' + (if pkgs.stdenv.isDarwin then ''''
    else ''
      Match host * exec "gpg-connect-agent UPDATESTARTUPTTY /bye"
    ''
    );
  };

}
