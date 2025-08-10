{lib, ...}: {
  imports = [
    ./common
    ./dev
    ./hardware
    ./networking
    ./security
    ./services
    ./steam
    ./wayland
    ./x11
  ];

  options = {
    custom.system-nixos = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable the system modules";
      };
    };
  };
}
