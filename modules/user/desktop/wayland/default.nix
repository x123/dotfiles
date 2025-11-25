{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hypr-config.nix
    ./sway-config.nix
  ];

  config = lib.mkIf (config.custom.user.desktop.enable
    && config.custom.user.desktop.wayland.enable
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
          scrot
          ;
        inherit
          (pkgs.nerd-fonts)
          code-new-roman
          ;
      };
    };
  };
}
