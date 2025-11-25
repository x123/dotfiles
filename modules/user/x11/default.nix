{pkgs, ...}: {
  imports = [
    ./i3-config.nix
  ];

  xresources.extraConfig = builtins.readFile (
    pkgs.fetchFromGitHub {
      owner = "nordtheme";
      repo = "xresources";
      rev = "ba3b1b61bf6314abad4055eacef2f7cbea1924fb";
      sha256 = "vw0lD2XLKhPS1zElNkVOb3zP/Kb4m0VVgOakwoJxj74=";
    } + "/src/nord"
  );

  home = {
    packages = with pkgs; [
      # term/shell
      #file
    ];

  };

}
