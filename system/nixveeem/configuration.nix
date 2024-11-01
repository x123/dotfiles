{
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/vmware-guest.nix")
    ./disk-config.nix
    ../../modules/nix-settings # do not remove
    ../../modules/system-nixos
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
    initrd.availableKernelModules = ["xhci_pci" "virtio_scsi" "sr_mod"];
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

  # sops = {
  #   defaultSopsFile = ./secrets.yaml;
  #
  #   age = {
  #     sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  #     keyFile = "/root/.config/sops/age/keys.txt";
  #     generateKey = true;
  #   };
  # };

  networking = {
    hostName = "nixveeem";
    domain = "31337";
    enableIPv6 = true;
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
    motdFile = ./files/nixveeem.motd;

    users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAV4W4TVF5yqOwKFax+b2XtRYbdKy1wy4zFXfFZfv5be xnix"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID6elYl8CWSR32Zx33D+XgQWM/721sDmnyFJec7vDeMb fom-mba"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGXOucJH+GXgiD/ro01zTxFOquY5g3oE6FULjV59Sgz nixpad"
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
      ];
    };
  };

  system.stateVersion = "24.05";
}
