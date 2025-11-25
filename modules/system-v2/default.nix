{lib, ...}: {
  imports = [
    ./common
    # ./darwin
    ./dev
    ./games
    ./hardware
    ./services
    ./x11
  ];

  options = {
    custom.system-v2 = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable the system modules";
      };
    };
  };
}
