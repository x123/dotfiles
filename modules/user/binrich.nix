{
  pkgs,
  flake-inputs,
  inputs,
  config,
  system,
  ...
}: {
  imports = [];

  home = {
    packages = [
      flake-inputs.binrich.packages.${pkgs.stdenv.hostPlatform.system}.binrich
      # inputs.binrich.packages.${pkgs.stdenv.hostPlatform.system}.binrich
    ];
  };
}
