{pkgs, ...}: {
  imports = [];

  home = {
    packages = with pkgs; [
      elixir
      nodejs
    ];
  };

}
