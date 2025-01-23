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

  boot = {
    binfmt.emulatedSystems = ["aarch64-linux"];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 100;
        memtest86.enable = true;
      };
      efi.canTouchEfiVariables = true;
    };

    initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" "usb_storage"];
    initrd.kernelModules = [];
    kernelParams = [];
    # kernelPackages = pkgs.linuxKernel.packages.linux_6_11;
    kernelPackages = pkgs.linuxPackages_latest; # lqx or zen or latest
    kernelModules = [
      "kvm-amd"
      "nct6683"
      # "v4l2loopback"
    ];
    extraModprobeConfig = ''
      options nct6683 force=1 force_id=0x2e
    '';
    blacklistedKernelModules = ["amdgpu"];
    # FIXME 2025-01-23 v4l2loopback is currently broken, see https://github.com/NixOS/nixpkgs/pull/375833
    # extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
  };

  services.fstrim.enable = true;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "ext4";
      options = ["noatime" "nodiratime"];
    };

    "/mnt/xdata" = {
      device = "/dev/disk/by-label/XDATA";
      fsType = "ext4";
      options = ["noatime" "nodiratime"];
    };
  };

  boot.initrd.luks.devices."luks-3062db9e-0454-4188-b0ba-d751be39e6b9" = {
    device = "/dev/disk/by-uuid/3062db9e-0454-4188-b0ba-d751be39e6b9";
    allowDiscards = true;
    bypassWorkqueues = true;
    keyFileSize = 4096;
    keyFile = "/dev/disk/by-id/usb-Kingston_DataTraveler_2.0_00173182460CBF80194DAB60-0:0";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXBOOT";
    fsType = "vfat";
  };

  swapDevices = [{device = "/dev/disk/by-label/NIXSWAP";}];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
