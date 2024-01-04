{ pkgs, ... }: {
  imports = [ ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home = {
    packages = with pkgs; [
      sqlite
      zig
    ];
  };

}
