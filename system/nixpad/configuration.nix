{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/bluetooth.nix
    ../../modules/system/cifs.nix
    ../../modules/system/console.nix
    ../../modules/system/locale.nix
    ../../modules/system/nix-settings.nix # do not remove
    # ../../modules/system/sound.nix
    ../../modules/system/x11.nix
    ../../modules/system/zsh.nix
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  };

  # allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowAliases = false;
  };

  # networking
  networking = {
    hostName = "nixpad";
    domain = "empire.boxchop.city";
  };

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
    allowedTCPPorts = [22];
    extraInputRules = ''
      ip saddr { 192.168.1.0/24, 192.168.9.0/24 } tcp dport {22} accept
    '';
  };

  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      git
      vim
      wget
      zsh
      ;
  };

  time.timeZone = "Europe/Copenhagen";

  users.users.x = {
    isNormalUser = true;
    description = "x";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    useDefaultShell = true;
  };

  system.stateVersion = "24.05";
}
