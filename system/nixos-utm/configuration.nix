# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/console.nix
    ../../modules/system/locale.nix
    ../../modules/system/nix-settings.nix # do not remove
    #../../modules/system/sound.nix
    ../../modules/system/x11.nix
    ../../modules/system/zsh.nix
    ];
  console = lib.mkForce {
    font = "${pkgs.powerline-fonts}/share/consolefonts/ter-powerline-v28n.psf.gz";
  };

  services.xserver.dpi = 180;
  virtualisation.rosetta.enable = true;

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "nixos-utm"; # Define your hostname.
  networking.networkmanager.enable = true;

  # packages
  environment.systemPackages = with pkgs; [
    git
    git-crypt
    vim
    wget
  ];

  time.timeZone = "Europe/Copenhagen";

  users.users.x = {
    isNormalUser = true;
    description = "x";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    useDefaultShell = true;
  };

  system.stateVersion = "23.11"; # Did you read the comment?

}

