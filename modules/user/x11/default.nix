{pkgs, ...}: {
  imports = [
    ./gtk.nix
    ./i3-config.nix
  ];

  xdg = {
    desktopEntries = {
      vim = {
        name = "vim";
        exec = "nvim %F";
        #exec = "setsid -f ghostty -e nvim %F";
        categories = ["Utility" "TextEditor"];
        mimeType = ["text/plain"];
        terminal = true;
      };
    };

    mime.enable = true;
    mimeApps = {
      enable = true;
      associations.added = {};
      associations.removed = {
        "text/plain" = ["calibre-ebook-viewer.desktop"];
      };
      defaultApplications = {
        "text/plain" = ["vim.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop"];
        "x-scheme-handler/http" = ["firefox.desktop"];
      };
    };
  };

  xresources.extraConfig = builtins.readFile (
    pkgs.fetchFromGitHub
    {
      owner = "nordtheme";
      repo = "xresources";
      rev = "ba3b1b61bf6314abad4055eacef2f7cbea1924fb";
      sha256 = "vw0lD2XLKhPS1zElNkVOb3zP/Kb4m0VVgOakwoJxj74=";
    }
    + "/src/nord"
  );

  home = {
    packages = with pkgs; [
      nerdfonts # very large
      scrot
    ];
  };
}
