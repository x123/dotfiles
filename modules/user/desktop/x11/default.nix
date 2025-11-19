{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./i3-config.nix
  ];

  config = lib.mkIf (config.custom.user.desktop.enable
    && config.custom.user.desktop.x11.enable
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
          font-awesome
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
          aurulent-sans-mono
          bigblue-terminal
          bitstream-vera-sans-mono
          blex-mono
          caskaydia-cove
          caskaydia-mono
          code-new-roman
          comic-shanns-mono
          commit-mono
          cousine
          d2coding
          daddy-time-mono
          dejavu-sans-mono
          departure-mono
          droid-sans-mono
          envy-code-r
          fantasque-sans-mono
          fira-code
          fira-mono
          geist-mono
          go-mono
          gohufont
          hack
          hasklug
          heavy-data
          hurmit
          im-writing
          inconsolata
          inconsolata-go
          inconsolata-lgc
          intone-mono
          iosevka
          iosevka-term
          iosevka-term-slab
          jetbrains-mono
          lekton
          liberation
          lilex
          martian-mono
          meslo-lg
          monaspace
          monofur
          monoid
          mononoki
          noto
          open-dyslexic
          overpass
          profont
          proggy-clean-tt
          recursive-mono
          roboto-mono
          sauce-code-pro
          shure-tech-mono
          space-mono
          symbols-only
          terminess-ttf
          tinos
          ubuntu
          ubuntu-mono
          ubuntu-sans
          victor-mono
          zed-mono
          ;
      };
    };
  };
}
