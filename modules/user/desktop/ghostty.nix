{
  pkgs,
  inputs,
  config,
  system,
  ...
}: {
  imports = [];

  home = {
    file.ghostty-conf = {
      target = "${config.xdg.configHome}/ghostty/config";
      source = ./ghostty.conf;
    };
    packages = [
      inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
