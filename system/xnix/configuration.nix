# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/bluetooth.nix
    ../../modules/system/cifs.nix
    ../../modules/system/console.nix
    ../../modules/system/locale.nix
    ../../modules/system/nix-settings.nix # do not remove
    ../../modules/system/nvidia.nix
    ../../modules/system/sound.nix
    ../../modules/system/steam.nix
    ../../modules/system/x11.nix
    ../../modules/system/zsh.nix
    ];

  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets.test_secret = {};

  nix.settings.trusted-substituters = ["https://ai.cachix.org"];
  nix.settings.trusted-public-keys = ["ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="];

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # networking
  networking.hostName = "xnix";
  networking.networkmanager.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
    extraInputRules = ''
      ip saddr { 192.168.1.0/24, 192.168.9.0/24 } tcp dport {22, 9090} accept
    '';
  };
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  environment.systemPackages = with pkgs; [
    git
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

  system.stateVersion = "23.05"; # Did you read the comment?
}
