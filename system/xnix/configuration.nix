# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/bluetooth.nix
    ../../modules/system/locale.nix
    ../../modules/system/nvidia.nix
    ../../modules/system/sound.nix
    ../../modules/system/steam.nix
    ../../modules/system/x11.nix
    ];

  # support nix flakes
  nix.package = pkgs.nixFlakes;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.fstrim.enable = true;

  networking.hostName = "xnix";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.x = {
    isNormalUser = true;
    description = "x";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    useDefaultShell = true;
  };

  programs.zsh.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

# List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    zsh
  ];

  system.stateVersion = "23.05"; # Did you read the comment?
}
