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

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  systemd.sleep.extraConfig = "HibernateDelaySec=1h";

  boot = {
    # binfmt.emulatedSystems = ["aarch64-linux"];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 100;
        memtest86.enable = true;
      };
      efi.canTouchEfiVariables = true;
    };

    initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" "usb_storage"];
    initrd.kernelModules = ["dm-snapshot"];
    kernelParams = [];
    kernelPackages = pkgs.linuxPackages_latest; # lqx or zen or latest
    kernelModules = [
      "kvm-intel"
      "v4l2loopback"
    ];
    blacklistedKernelModules = [];
    extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
  };

  services.fstrim.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/da272ae4-388e-4908-9715-91e84e23ace5";
    fsType = "ext4";
    options = ["noatime" "nodiratime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/53A8-75EB";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  boot.initrd.luks.devices."luks-1dc251b2-ea87-4005-915e-764bb03f7a11" = {
    device = "/dev/disk/by-uuid/1dc251b2-ea87-4005-915e-764bb03f7a11";
    allowDiscards = true;
    bypassWorkqueues = true;
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/a4a607c8-b731-4318-b0fb-5ff8da2d6574";}
  ];

  networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  networking.interfaces.wlp61s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
