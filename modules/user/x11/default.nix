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
      defaultApplications = {
        "text/plain" = ["vim.desktop"];
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
    packages = builtins.attrValues {
      inherit
        (pkgs)
        nerdfonts # very large
        scrot
        ;
    };
  };
}
