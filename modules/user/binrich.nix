{ pkgs, osConfig, inputs, config, system, ... }: {
  imports = [ ];

  home = {
    packages = [
      #inputs.binrich.packages.${pkgs.stdenv.hostPlatform.system}.binrich
    ];
  };

}
