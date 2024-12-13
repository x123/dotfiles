{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./i3-config.nix
  ];

  config = lib.mkIf (config.custom.desktop.enable
    && config.custom.desktop.x11.enable
    && !pkgs.stdenv.isDarwin) {
    xdg = {
      desktopEntries = {
        vim = {
          name = "vim";
          exec = "nvim %F";
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
          material-symbols
          powerline-fonts
          scrot
          ;
        inherit
          (pkgs.nerd-fonts)
          _0xproto
          _3270
          agave
          anonymice
          arimo
          blex-mono
          code-new-roman
          cousine
          d2coding
          dejavu-sans-mono
          fira-code
          fira-mono
          go-mono
          gohufont
          hack
          hasklug
          hurmit
          iosevka
          lekton
          lilex
          meslo-lg
          monofur
          monoid
          mononoki
          mplus
          noto
          overpass
          profont
          tinos
          ubuntu
          zed-mono
          ;
      };
    };
  };
}
