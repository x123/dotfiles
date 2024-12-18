{pkgs, ...}: {
  imports = [
    ./disk-config.nix
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
    games.enable = false;

    hardware = {
      bluetooth.enable = false;
      nvidia.enable = false;
      sound.enable = false;
    };

    networking.tornet.enable = true;

    services = {
      invidious = {
        enable = false;
      };

      open-webui = {
        enable = false;
      };

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
      nix-ssh-serve.enable = false;
    };

    x11.enable = true;
  };

  # vm specific settings
  # Share our host filesystem
  fileSystems."/host" = {
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    device = ".host:/";
    options = [
      "umask=22"
      "uid=1000"
      "gid=1000"
      "allow_other"
      "auto_unmount"
      "defaults"
    ];
  };

  virtualisation.vmware.guest.enable = true;

  services.libinput.enable = true;
  services.xserver.dpi = 224;

  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };

  boot = {
    binfmt.emulatedSystems = ["x86_64-linux"];
    initrd.availableKernelModules = ["uhci_hcd" "ahci" "xhci_pci" "nvme" "usbhid" "sr_mod"];
    initrd.kernelModules = [];
    kernelModules = [];
    extraModulePackages = [];
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 20;
      consoleMode = "max";
    };
    loader.efi.canTouchEfiVariables = true;
  };

  nixpkgs.config.allowAliases = false;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

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
    hostName = "vm";
    domain = "local";
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
      git
      gtkmm3
      # xclip
      
      ;
  };

  time.timeZone = "Europe/Copenhagen";

  users = {
    users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAV4W4TVF5yqOwKFax+b2XtRYbdKy1wy4zFXfFZfv5be xnix"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID6elYl8CWSR32Zx33D+XgQWM/721sDmnyFJec7vDeMb fom-mba"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGXOucJH+GXgiD/ro01zTxFOquY5g3oE6FULjV59Sgz nixpad"
    ];

    users.x = {
      createHome = true;
      isNormalUser = true;
      description = "x";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;
      useDefaultShell = true;
      initialHashedPassword = "$y$j9T$44zWKQ/pvpxKAfYLxYQzB.$NhVjb.bYbhXbtL0Sf15LTZ0Asy/leKAlc6OtMbROY/.";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAV4W4TVF5yqOwKFax+b2XtRYbdKy1wy4zFXfFZfv5be xnix"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID6elYl8CWSR32Zx33D+XgQWM/721sDmnyFJec7vDeMb fom-mba"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGXOucJH+GXgiD/ro01zTxFOquY5g3oE6FULjV59Sgz nixpad"
      ];
    };
  };

  system.stateVersion = "24.05";
}
