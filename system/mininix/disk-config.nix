{lib, ...}: {
  disko.devices = {
    disk = {
      sda = {
        device = lib.mkDefault "/dev/sda";
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
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            # plainSwap = {
            #   size = "4000M";
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
