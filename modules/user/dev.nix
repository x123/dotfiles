{pkgs, ...}: {
  imports = [];

  home = {
    packages = with pkgs; [
      elixir
      erlang
      nodejs
      sqlite
    ];
  };

}
