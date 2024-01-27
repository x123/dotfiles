{pkgs, ...}: {
  imports = [];

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
    packages = builtins.attrValues {
      inherit
        (pkgs)
        fd # optional, for file searching
        ffmpegthumbnailer # optional, for video thumbnails
        fzf # optional, for quick file subtree navigation
        jq # optional, for JSON preview
        poppler # optional, for PDF preview
        ripgrep # for file content searching
        unar # optional, for archive preview
        yazi # REQUIRED
        zoxide # optional, for historical directories navigation
        ;
    };

    shellAliases = {
      y = "yazi";
    };
  };
}
