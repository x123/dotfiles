{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nix-settings # do not remove
    ../../modules/system-nixos

    ./local/nftables-syncthing.nix
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

      jellyfin = {
        enable = true;
        openFirewallNftables = true;
        trustedIpv4Networks = [
          "192.168.1.0/24"
          "192.168.9.0/24"
        ];
        trustedIpv6Networks = [
          "fdab:817c:904c::1/60" # gk-2
          "fd65:4e21:dde4::/60" # gk
        ];
      };

      sonarr = {
        enable = false;
        openFirewallNftables = true;
        group = config.users.users.xdata.group;
        trustedIpv4Networks = [
          "192.168.1.0/24"
          "192.168.9.0/24"
        ];
        # trustedIpv6Networks = [
        #   "fdab:817c:904c::1/60" # gk-2
        #   "fd65:4e21:dde4::/60" # gk
        # ];
      };

      nftables.enable = true;
      nix-ssh-serve.enable = false;

      tang = {
        enable = true;
        openFirewallNftables = true;
        trustedIpv4Networks = [
          "127.0.0.1/24"
          "192.168.1.0/24"
          "192.168.9.0/24"
        ];
        trustedIpv6Networks = [
          "fdab:817c:904c::/60" # gk-2
          "fd65:4e21:dde4::/60" # gk
        ];
      };

      qdrant.enable = true;
    };

    steam.enable = true;
    wayland.enable = false;
    x11.enable = true;
  };

  # nix.settings = {
  #   cores = 14;
  #   max-jobs = 1;
  # };

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

  users.groups.xdata = {};
  users.users.xdata = {
    isSystemUser = true;
    description = "xdata";
    group = "xdata";
  };

  nix = {
    settings.trusted-users = ["builder"];
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
  };

  users.users = {
    builder = {
      isNormalUser = true;
      description = "builder";
      shell = pkgs.zsh;
      useDefaultShell = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEn0u0tbuy5pbF5oGkcLQIe+fGYE7vllDaiix/qfvnEw root@mini"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPcS29HjO7PMB6JJmXLO90uJ2hB4952TdbjGBW1vFPPR root@privnix"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO7DL0W0H5iGt0SYO2OnUxhSa7C0eaGTcPKxGFMICj1F root@wgnix-vm"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ12Vj1i469avRzGH1NxENkwGlHu8L/hpP6rop6FsyjV root@transmission"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFC75+eYCJ0gY9nTUVJy/hw0SFb84BLBrRsjWfotg6N6 root@unboundednix"
      ];
    };
    x = {
      isNormalUser = true;
      description = "x";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;
      useDefaultShell = true;
      initialHashedPassword = "$2b$05$xfNWBnjifpR7HFG1rPKbde/rUZdwaTRMLDVJIxAMv6fbkjc5NFm8W";
      openssh.authorizedKeys.keys = config.custom.common.sshKeys.adminKeys;
    };
  };

  system.stateVersion = "23.05"; # Did you read the comment?
}
