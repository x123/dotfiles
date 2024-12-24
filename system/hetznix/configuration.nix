{
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ../../modules/nix-settings # do not remove
    ../../modules/system-nixos
    ./local/acme.nix
    ./local/borgmatic.nix
    ./local/caddy.nix
    ./local/dovecot.nix
    ./local/mastodon.nix
    ./local/nftables-blackhole.nix
    ./local/nftables-http.nix
    ./local/nftables-knock.nix
    # ./local/nftables-netperf.nix
    ./local/nginx.nix
    ./local/ntfy.nix
    ./local/postfix.nix
    ./local/postgres.nix
    ./local/uptime-kuma.nix
  ];

  custom.system-nixos = {
    enable = true;

    services = {
      openssh = {
        enable = true;
        openFirewallNftables = false;
        trustedIpv4Networks = [
          "0.0.0.0/0"
        ];
        trustedIpv6Networks = [
          "::/0"
        ];
      };

      nftables.enable = true;
    };
  };

  boot = {
    binfmt.emulatedSystems = ["x86_64-linux"];
    initrd.availableKernelModules = ["xhci_pci" "virtio_scsi" "sr_mod"];
    initrd.kernelModules = [];
    kernelModules = [];
    extraModulePackages = [];
    kernelPackages = pkgs.linuxKernel.packages.linux_6_11; # 2024-12-24 nftables kernel alignment https://lore.kernel.org/stable/Z2V3fhnOaOMcCtUt@calendula/T/
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

  networking = {
    hostName = "hetznix";
    domain = "boxchop.city";
    enableIPv6 = true;
    interfaces.enp1s0.ipv6.addresses = [
      {
        address = "2a01:4f8:1c1b:51d1::1";
        prefixLength = 64;
      }
    ];
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp1s0";
    };
  };

  # services.openssh = {
  #   enable = true;
  #   openFirewall = true;
  #   settings = {
  #     PasswordAuthentication = false;
  #     KbdInteractiveAuthentication = false;
  #   };
  # };

  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      vim
      wget
      ;
  };

  users = {
    motdFile = ./files/hetznix.motd;

    users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAV4W4TVF5yqOwKFax+b2XtRYbdKy1wy4zFXfFZfv5be xnix"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID6elYl8CWSR32Zx33D+XgQWM/721sDmnyFJec7vDeMb fom-mba"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMXxyU8SafRkTGJ3ZGMlsl9iXu7Yb+IT2R2OHg0KVx+E fom-mbp"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGXOucJH+GXgiD/ro01zTxFOquY5g3oE6FULjV59Sgz nixpad"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKkPCWWFGc0PYrwwpzpykM20aXZxLLd+hD8/W4ga7nAA x@vm"
    ];

    users.x123 = {
      createHome = true;
      isNormalUser = true;
      description = "x123";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;
      useDefaultShell = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAV4W4TVF5yqOwKFax+b2XtRYbdKy1wy4zFXfFZfv5be xnix"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID6elYl8CWSR32Zx33D+XgQWM/721sDmnyFJec7vDeMb fom-mba"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGXOucJH+GXgiD/ro01zTxFOquY5g3oE6FULjV59Sgz nixpad"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKkPCWWFGc0PYrwwpzpykM20aXZxLLd+hD8/W4ga7nAA x@vm"
      ];
    };
  };

  system.stateVersion = "24.05";
}
