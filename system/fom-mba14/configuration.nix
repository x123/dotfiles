# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
  ../../modules/system/darwin/karabiner.nix
  ../../modules/system/darwin/yabai.nix
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
  users.users.fom.shell = pkgs.bash;

  #environment.pathsToLink = [ "/share/bash-completion" ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.extra-platforms = "x86_64-darwin";

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

  system.defaults = {
	dock = {
	  autohide = true;
	  #orientation = "right";
	};

	finder = {
	  AppleShowAllExtensions = true;
	  _FXShowPosixPathInTitle = true;
	  FXEnableExtensionChangeWarning = false;
	};
  };

  # Set Git commit hash for darwin-version.
  #system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
