{ modulesPath, pkgs, ... }:
{
  imports =
    [
      (modulesPath + "/virtualisation/google-compute-image.nix")
      ../../modules/system/zsh.nix
    ];

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
