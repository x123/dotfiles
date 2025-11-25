{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nix-settings # do not remove
    ../../modules/system-nixos
  ];

  custom.system-nixos = {
    enable = true;

    common = {
      console-theme.enable = false;
    };

    dev = {
      enable = false;
      elixir.enable = false;
    };

    hardware = {
      bluetooth.enable = true;
      laptop.enable = true;
      nvidia.enable = false;
      sound.enable = true;
    };

    networking.tornet.enable = true;
    security = {
      apparmor.enable = true;
      auditd.enable = true;
      firejail.enable = true;
    };

    services = {
      openssh = {
        enable = true;
        openFirewallNftables = true;
        trustedIpv4Networks = [
          "192.168.1.0/24"
          "192.168.9.0/24"
        ];
        trustedIpv6Networks = [
          "fdab:817c:904c::1/60" # gk-2
          "fd65:4e21:dde4::1/60" # gk
        ];
      };

      jellyfin.enable = false;
      nftables.enable = true;
    };

    steam.enable = false;
    wayland.enable = false;
    x11.enable = true;
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  };

  # allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowAliases = false;
  };

  # nix.settings.builders = lib.mkForce ''
  #   x@xnix.empire.internal  x86_64-linux /home/x/.ssh/id_builder
  # '';

  # networking
  networking = {
    hostName = "nixpad";
    domain = "empire.internal";
    networkmanager.enable = true;
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
    openssh.authorizedKeys.keys = config.custom.common.sshKeys.adminKeys;
  };

  system.stateVersion = "24.05";
}
