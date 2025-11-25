{pkgs, ...}: {
  xdg = {
    desktopEntries = {
      steam-coreparked = {
        name = "steam-coreparked";
        exec = "${pkgs.util-linux}/bin/taskset -a -c 0-7,16-23 steam";
        categories = ["Application"];
        terminal = false;
      };
    };
  };

  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      gamemode
      mangohud
      ;
  };
}
