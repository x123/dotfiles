{ modulesPath, pkgs, ... }:
{
  imports =
    [
      (modulesPath + "/virtualisation/google-compute-image.nix")
      ../../modules/system/nix-settings.nix # do not remove
      ../../modules/system/zsh.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_zen; # lqx or zen or latest

  networking = {
    hostName = "nixium";
    domain = "boxchop.city";
  };

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  users.motdFile = ./files/nixium.motd;

  users.users.x = {
    createHome = true;
    isNormalUser = true;
    description = "x";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    useDefaultShell = true;
  };

  system.stateVersion = "24.05";

}
