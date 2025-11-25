{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ../../modules/system/nix-settings.nix # do not remove
    ../../modules/system/zsh.nix
  ];

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "virtio_scsi" "sr_mod"];
    initrd.kernelModules = [];
    kernelModules = [];
    extraModulePackages = [];
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
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
  };

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAV4W4TVF5yqOwKFax+b2XtRYbdKy1wy4zFXfFZfv5be"
    ];

    users.x123 = {
      createHome = true;
      isNormalUser = true;
      description = "x123";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;
      useDefaultShell = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAV4W4TVF5yqOwKFax+b2XtRYbdKy1wy4zFXfFZfv5be"
      ];
    };
  };

  system.stateVersion = "24.05";
}
