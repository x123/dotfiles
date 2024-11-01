{lib, ...}: {
  disko.devices = {
    disk = {
      nvme0n1 = {
        device = lib.mkDefault "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "1M";
              type = "EF02";
            };
            ESP = {
              name = "ESP";
              size = "1000M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            # plainSwap = {
            #   size = "1000M";
            #   content = {
            #     type = "swap";
            #     resumeDevice = true;
            #   };
            # };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = ["defaults"];
              };
            };
          };
        };
      };
    };
  };
}
