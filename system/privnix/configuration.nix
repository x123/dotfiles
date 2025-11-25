{
  modulesPath,
  pkgs,
  config,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ../../modules/nix-settings # do not remove
    ../../modules/system-nixos

    # ./local/i2p.nix
    ./local/irc.nix
  ];

  custom.system-nixos = {
    enable = true;

    xnix-builder.enable = true;
    hardware.qemu-guest.enable = true;

    services = {
      openssh = {
        enable = true;
        openFirewallNftables = true;
        trustedIpv4Networks = [
          "192.168.1.0/24"
          "192.168.9.0/24"
        ];
        trustedIpv6Networks = [];
      };

      nftables.enable = true;
    };
  };

  boot = {
    # binfmt.emulatedSystems = ["x86_64-linux"];
    initrd.availableKernelModules = [
      "ata_piix"
      "sd_mod"
      "sr_mod"
      "uhci_hcd"
      "virtio_pci"
      "virtio_scsi"
      "xhci_pci"
    ];
    initrd.kernelModules = [];
    kernelModules = [];
    extraModulePackages = [];
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 4;
    };
    loader.efi.canTouchEfiVariables = true;
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;

    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/root/.config/sops/age/keys.txt";
      generateKey = true;
    };
  };

  boot.kernel.sysctl."net.ipv6.conf.all.disable_ipv6" = true;

  networking = {
    hostName = "privnix";
    domain = "empire.internal";
    enableIPv6 = false;
    # useNetworkd = true; # not needed when using systemd.network.enable = true
    dhcpcd.enable = false;
    useDHCP = false;
    resolvconf = {
      enable = true;
      # this is needed to disable the domain entry in /etc/resolv.conf
      extraConfig = ''
        replace=domain/${config.networking.domain}/
      '';
    };
    nameservers = ["192.168.1.127"];
    search = [];
  };

  systemd.network = {
    enable = true;
    networks."98-ens18" = {
      matchConfig.Name = "enp6s18";
      networkConfig = {
        DNS = [
          "192.168.1.127"
        ];
        MulticastDNS = false;
        LLMNR = false;
        # DHCP = "ipv4";
        IPv6AcceptRA = false;
        # LinkLocalAddressing=false; # disable all LinkLocalAddressing
        IPv6LinkLocalAddressGenerationMode = "none"; # disable just IPv6 Link Local Address Generation
      };
      address = [
        "192.168.1.151/24"
      ];
      # routes = [
      #   {Gateway = "192.168.1.1";}
      # ];
      linkConfig.RequiredForOnline = "routable";
    };
    networks."99-ens19" = {
      matchConfig.Name = "enp6s19";
      networkConfig = {
        # DNS = [
        #   "192.168.1.127"
        # ];
        MulticastDNS = false;
        LLMNR = false;
        # DHCP = "ipv4";
        IPv6AcceptRA = false;
        # LinkLocalAddressing=false; # disable all LinkLocalAddressing
        IPv6LinkLocalAddressGenerationMode = "none"; # disable just IPv6 Link Local Address Generation
      };
      address = [
        "10.10.10.8/24"
      ];
      routes = [
        {Gateway = "10.10.10.253";}
      ];
      linkConfig.RequiredForOnline = "routable";
    };
  };

  # systemd-resolved disalbed for now (favoring old-school resolvconf)
  services.resolved = {
    enable = false; # commenting this out will cause resolvconf to fail
    fallbackDns = ["192.168.1.127"];
    llmnr = "false";
    # this prevents the 127.0.0.53 stub resolver
    extraConfig = ''
      DNSStubListener=no
    '';
  };

  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      git
      tmux
      vim
      weechat
      wget
      ;
  };

  users = {
    users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAV4W4TVF5yqOwKFax+b2XtRYbdKy1wy4zFXfFZfv5be xnix"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID6elYl8CWSR32Zx33D+XgQWM/721sDmnyFJec7vDeMb fom-mba"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMXxyU8SafRkTGJ3ZGMlsl9iXu7Yb+IT2R2OHg0KVx+E fom-mbp"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGXOucJH+GXgiD/ro01zTxFOquY5g3oE6FULjV59Sgz nixpad"
    ];

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
