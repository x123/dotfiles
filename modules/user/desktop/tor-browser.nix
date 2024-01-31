{
  pkgs,
  config,
  ...
}: {
  imports = [];

  home = {
    packages = [
      pkgs.tor-browser
    ];
  };
}
