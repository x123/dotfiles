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
    games.enable = true;

    hardware = {
      bluetooth.enable = true;
      nvidia.enable = true;
      sound.enable = true;
    };

    services = {
      invidious = {
        enable = true;
        domain = "invidious.xnix.lan";
        openFirewallNftables = true;
        trustedIpv4Networks = [
          "192.168.1.0/24"
          "192.168.9.0/24"
        ];
        trustedIpv6Networks = [
          "fd65:4e21:dde4::1/60"
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
          "fd65:4e21:dde4::1/60"
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
          "fd65:4e21:dde4::1/60"
        ];
      };

      jellyfin.enable = false;
      nftables.enable = true;
      nix-ssh-serve.enable = false;
    };

    x11.enable = true;
  };

  users.groups.ssl = {};

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

    secrets = {
      "ssl/invidious.xnix.lan/cert" = {
        mode = "0644";
        owner = config.users.users.root.name;
        group = config.users.groups.ssl.name;
      };
      "ssl/invidious.xnix.lan/key" = {
        mode = "0640";
        owner = config.users.users.root.name;
        group = config.users.groups.ssl.name;
      };

      "muttrc" = {
        mode = "0400";
        owner = config.users.users.x.name;
        #group = "wheel";
      };

      "tg/nixiumbot" = {
        mode = "0440";
        owner = config.users.users.root.name;
        group = "wheel";
      };
    };
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
    domain = "empire.boxchop.city";
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
  };

  system.stateVersion = "23.05"; # Did you read the comment?
}
