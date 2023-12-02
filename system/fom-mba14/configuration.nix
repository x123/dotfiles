# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports = [
  ../../modules/system/darwin/karabiner.nix
  ../../modules/system/nix-settings.nix # do not remove
  ../../modules/system/darwin/yabai.nix
  ../../modules/system/darwin/skhd.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  environment.shells = with pkgs; [
    bash
    zsh
  ];

  environment.variables = {
    EDITOR = "vim";
  };

  # users
  users.users.fom.shell = pkgs.bash;

  # nix settings
  nix.settings.extra-platforms = "x86_64-darwin";
  nix.settings.allowed-users = [
    "@admin"
    "fom"
  ];

  services.nix-daemon.enable = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh = {
    enable = true;  # default shell on catalina
    enableCompletion = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  # Set Git commit hash for darwin-version.
  #system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
