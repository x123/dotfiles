{
  modulesPath,
  pkgs,
  config,
  ...
}: {
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ../../modules/nix-settings
    ../../modules/system-nixos

    ./local/unbound.nix
  ];

  nix.settings = {sandbox = false;};

  proxmoxLXC = {
    privileged = false;
    manageNetwork = true;
    manageHostName = true;
  };

  services.fstrim.enable = false; # Let Proxmox host handle fstrim

  custom.system-nixos = {
    enable = true;
    xnix-builder.enable = true;

    services = {
      openssh = {
        enable = true;
        openFirewallNftables = true;
        trustedIpv4Networks = ["0.0.0.0/0"];
        trustedIpv6Networks = ["::/0"];
      };
      nftables.enable = true;
    };
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/root/.config/sops/age/keys.txt";
      generateKey = true;
    };
  };

  networking = {
    hostName = "unboundednix";
    domain = "empire.internal";
    enableIPv6 = false;
    dhcpcd.enable = false;
    useDHCP = false;
    resolvconf = {
      enable = true;
      extraConfig = ''
        replace=domain/${config.networking.domain}/
      '';
    };
    nameservers = ["192.168.1.1"];
    search = [];
  };

  systemd.network = {
    enable = true;
    networks."99-ethernet" = {
      matchConfig.Name = "eth0";
      networkConfig = {
        DNS = ["192.168.1.1"];
        MulticastDNS = false;
        LLMNR = false;
        IPv6AcceptRA = false;
        IPv6LinkLocalAddressGenerationMode = "none";
      };
      address = [
        "192.168.1.165/24"
      ];
      routes = [
        {
          Gateway = "192.168.1.1";
        }
      ];
      linkConfig.RequiredForOnline = "routable";
    };
  };

  services.resolved = {
    enable = false;
    fallbackDns = ["192.168.1.1"];
    llmnr = "false";
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) git vim wget;
  };

  users = {
    users.root.openssh.authorizedKeys.keys = config.custom.common.sshKeys.adminKeys;

    users.x123 = {
      createHome = true;
      isNormalUser = true;
      description = "x123";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;
      useDefaultShell = true;
      openssh.authorizedKeys.keys = config.custom.common.sshKeys.adminKeys;
    };
  };

  system.stateVersion = "25.11";
}
