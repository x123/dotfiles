{ pkgs, ... }: {
  imports = [ ];

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
  };

}
