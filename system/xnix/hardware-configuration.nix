{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  sops.secrets = {
    "dropbear-keys/pub" = {
      mode = "0444";
    };
    "dropbear-keys/priv" = {
      mode = "0400";
    };
  };

  powerManagement = {
    enable = true;
    # can be ondemand, powersave, performance
    cpuFreqGovernor = "powersave";
  };

  boot = {
    binfmt = {
      emulatedSystems = ["aarch64-linux"];
      preferStaticEmulators = true; # required to work with podman
    };
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 100;
        memtest86.enable = true;
      };
      efi.canTouchEfiVariables = true;
    };

    tmp = {
      useTmpfs = true;
      tmpfsSize = "75%";
    };
    initrd = {
      network = {
        enable = true;
        udhcpc = {
          enable = true;
          extraArgs = ["-i" "enp5s0"]; # to specify an interface for quicker boot
        };

        ssh = {
          enable = true;
          port = 2222;
          authorizedKeys = config.custom.common.sshKeys.adminKeys;
          hostKeys = [config.sops.secrets."dropbear-keys/priv".path];
        };
      };

      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "sd_mod"
        "usb_storage"
        "r8169" # critical for networking in initrd
      ];
      kernelModules = [];

      # # USB auto-unlock
      # postDeviceCommands = lib.mkAfter ''
      #   zfs_pool="xnixtank"
      #   # TARGET THE ENCRYPTION ROOT (The Pool itself)
      #   zfs_ds="xnixtank"
      #   key_drive="/dev/disk/by-id/usb-Kingston_DataTraveler_2.0_00173182460CBF80194DAB60-0:0"
      #
      #   # Wait for USB to settle
      #   sleep 2
      #
      #   if [ -e "$key_drive" ]; then
      #     echo ">>> USB Key detected. Importing Pool..."
      #     # Import safely without mounting (-N)
      #     zpool import -N -f "$zfs_pool" || true
      #
      #     echo ">>> Attempting to unlock $zfs_ds..."
      #     # Read 4096 bytes (legacy behavior) and pipe to zfs load-key
      #     # We use -r to ensure children are recognized as unlocked
      #     head -c 4096 "$key_drive" | zfs load-key -r "$zfs_ds" && echo ">>> ZFS Key Loaded Successfully."
      #   else
      #     echo ">>> USB Key not found."
      #   fi
      # '';
      #
      # # zfsunlock for ssh unlocking
      # extraUtilsCommands = ''
      #   cat > $out/bin/zfsunlock <<EOF
      #   #!/bin/sh
      #   echo "Unlocking ZFS Pool: xnixtank"
      #   read -s -p "Enter Passphrase: " PASS
      #   echo
      #   # Import if not already imported (silently)
      #   zpool import -N -f xnixtank 2>/dev/null
      #
      #   # Load key
      #   echo "\$PASS" | zfs load-key -r xnixtank
      #
      #   if [ \$? -eq 0 ]; then
      #     echo "Success. Dataset unlocked."
      #     echo "You may now type 'exit' to continue boot."
      #   else
      #     echo "Failed to load key."
      #   fi
      #   EOF
      #   chmod +x $out/bin/unlock-zfs
      # '';

      luks.devices = {
        # samsung-990-pro (NEWBOOT/NEWROOT)
        # "luks-samsung-990-pro" = {
        #   device = "/dev/disk/by-uuid/092a6c39-88d0-4714-83cd-b58bc177ffad";
        #   allowDiscards = true;
        #   bypassWorkqueues = true;
        #   keyFileSize = 4096;
        #   keyFile = "/dev/disk/by-id/usb-Kingston_DataTraveler_2.0_00173182460CBF80194DAB60-0:0";
        #   fallbackToPassword = true;
        # };
      };
    };

    kernelParams = [
      # "pcie_aspm.policy=powersave"
      # "pcie_aspm.policy=powersupersave"
      "pcie_aspm.policy=performance"
    ];
    # kernelPackages = pkgs.linuxKernel.packages.linux_6_11;
    kernelPackages = pkgs.linuxPackages_latest; # lqx or zen or latest
    kernel.sysctl = {
      "kernel.nmi_watchdog" = false;
      "kernel.task_delayacct" = 1; # for iotop to work
      # "net.netfilter.nf_conntrack_tcp_timeout_time_wait" = 120;
      # "net.netfilter.nf_conntrack_tcp_timeout_established" = 7200;
    };
    kernelModules = [
      "kvm-amd"
      "nct6683"
      "v4l2loopback"
    ];
    extraModprobeConfig = ''
      options nct6683 force=1 force_id=0x2e
    '';
    blacklistedKernelModules = ["amdgpu"];
    extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
    # optional, but ensures rpc-statsd is running for on demand nfs mounting
    supportedFilesystems = [
      "btrfs"
      "nfs"
      "zfs"
    ];
  };

  services.fstrim.enable = true;

  # required for ZFS pool metadata
  networking.hostId = "d7219f63";

  fileSystems = {
    "/" = {
      device = "xnixtank/state/root";
      fsType = "zfs";
    };

    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };

    "/home" = {
      device = "xnixtank/state/home";
      fsType = "zfs";
    };

    "/nix" = {
      device = "xnixtank/scratch/nix";
      fsType = "zfs";
      # options = ["noatime" "nodiratime"];
    };

    "/nix/var/nix/builds" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "size=75%"
        "mode=755"
        "nosuid"
        "nodev"
        "noatime"
        "nodiratime"
      ];
    };

    "/home/x/.local/share/Steam" = {
      device = "xnixtank/scratch/user/x/steam";
      fsType = "zfs";
      neededForBoot = false;
    };

    "/home/x/.bm" = {
      device = "xnixtank/scratch/user/x/bm";
      fsType = "zfs";
      neededForBoot = false;
    };

    "/home/x/.cache" = {
      device = "xnixtank/scratch/user/x/cache";
      fsType = "zfs";
      neededForBoot = false;
    };

    "/home/x/.ollama" = {
      device = "xnixtank/scratch/user/x/ollama";
      fsType = "zfs";
      neededForBoot = false;
    };

    "/home/x/Dropbox" = {
      device = "xnixtank/state/user/x/dropbox";
      fsType = "zfs";
      neededForBoot = false;
    };

    "/home/x/src" = {
      device = "xnixtank/state/user/x/src";
      fsType = "zfs";
      neededForBoot = false;
    };

    "/mnt/truenas/iron/xdata" = {
      device = "truenas.empire.internal:/mnt/iron/xdata";
      fsType = "nfs";
      options = ["x-systemd.automount" "noauto" "noatime" "rsize=1048576" "wsize=1048576"];
    };

    "/mnt/truenas/iron/creative/f" = {
      device = "truenas.empire.internal:/mnt/iron/creative/f";
      fsType = "nfs";
      options = ["x-systemd.automount" "noauto" "noatime" "rsize=1048576" "wsize=1048576"];
    };

    "/mnt/truenas/iron/critical/f" = {
      device = "truenas.empire.internal:/mnt/iron/critical/f";
      fsType = "nfs";
      options = ["x-systemd.automount" "noauto" "noatime" "rsize=1048576" "wsize=1048576"];
    };

    "/mnt/truenas/iron/memories/shared" = {
      device = "truenas.empire.internal:/mnt/iron/memories/shared";
      fsType = "nfs";
      options = ["x-systemd.automount" "noauto" "noatime" "rsize=1048576" "wsize=1048576"];
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/NIXSWAP_B";
      priority = 0;
    }
    {
      device = "/dev/disk/by-label/NIXSWAP_ALT";
      priority = 0;
    }
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
