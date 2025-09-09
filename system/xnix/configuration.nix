{
  config,
  pkgs,
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
      filesystems.enable = true;
    };

    dev.elixir.enable = false;

    hardware = {
      bluetooth.enable = true;
      nvidia.enable = true;
      sound.enable = true;
      via.enable = true;
    };

    networking = {
      mullvad.enable = true;
      tornet.enable = true;
      wireguard.enable = false;
    };

    security = {
      apparmor.enable = true;
      auditd.enable = true;
      firejail.enable = true;
    };

    services = {
      docker.enable = true;
      ollama = {
        enable = true;
        host = "192.168.1.131";
        port = 11434;
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

      open-webui = {
        enable = false;
        host = "127.0.0.1";
        port = 8080;
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

      openssh = {
        enable = true;
        openFirewallNftables = true;
        trustedIpv4Networks = [
          "192.168.1.0/24"
          "192.168.9.0/24"
        ];
        trustedIpv6Networks = [
          "fdab:817c:904c::/60" # gk-2
          "fd65:4e21:dde4::/60" # gk
        ];
      };

      jellyfin.enable = true;
      nftables.enable = true;
      nix-ssh-serve.enable = false;
      qdrant.enable = true;
    };

    steam.enable = true;
    wayland.enable = false;
    x11.enable = true;
  };

  users.groups.ssl = {};

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  };

  # allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowAliases = false;
    nvidia.acceptLicense = true;
  };

  # networking
  networking = {
    hostName = "xnix";
    domain = "empire.internal";
    networkmanager.enable = true;
  };

  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      git
      vim
      wget
      ;
  };

  time.timeZone = "Europe/Copenhagen";

  # security.sudo.extraRules = [
  #   {
  #     users = [config.users.users.x.name];
  #     commands = [
  #       {
  #         command = "ALL";
  #         options = ["NOPASSWD"];
  #       }
  #     ];
  #   }
  # ];

  users.users.x = {
    isNormalUser = true;
    description = "x";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    useDefaultShell = true;
    initialHashedPassword = "$2b$05$xfNWBnjifpR7HFG1rPKbde/rUZdwaTRMLDVJIxAMv6fbkjc5NFm8W";
    openssh.authorizedKeys.keys = config.custom.common.sshKeys.adminKeys;
  };

  system.stateVersion = "23.05"; # Did you read the comment?
}
