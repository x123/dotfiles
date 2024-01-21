{ pkgs, ... }: {
  imports = [ ];

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      manager = {
        show_hidden = false;
        sort_by = "modified";
        linemode = "mtime";
      };
    };
    #    keymap = {
    #      manager.keymap = [
    #        { exec = "arrow -100%"; on = [ "<PageUp>" ];}
    #        { exec = "arrow 100%"; on = [ "<PageDown>" ];}
    #      ];
    #    };
  };

  home = {
    packages = with pkgs; [
      yazi

      ffmpegthumbnailer # optional, for video thumbnails
      unar # optional, for archive preview
      jq # optional, for JSON preview
      poppler # optional, for PDF preview
      fd # optional, for file searching
      ripgrep # for file content searching
      fzf # optional, for quick file subtree navigation
      zoxide # optional, for historical directories navigation
    ];

    shellAliases = {
      y = "yazi";
    };
  };

}
