{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.system-nixos.services.xmrig = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the system xmrig service";
      };
      package = lib.mkPackageOption pkgs "xmrig" {
        example = "xmrig-mo";
      };
      configFile = lib.mkOption {
        default = null;
        type = lib.types.str;
        description = "path to config file";
      };
    };
  };

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.services.xmrig.enable) {
    hardware.cpu.x86.msr.enable = true;

    systemd.services.xmrig = {
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      description = "XMRig Mining Software Service";
      serviceConfig = {
        ExecStartPre = "${lib.getExe config.custom.system-nixos.services.xmrig.package} --config=${config.custom.system-nixos.services.xmrig.configFile} --dry-run";
        ExecStart = "${lib.getExe config.custom.system-nixos.services.xmrig.package} --config=${config.custom.system-nixos.services.xmrig.configFile}";
        # https://xmrig.com/docs/miner/randomx-optimization-guide/msr
        # If you use recent XMRig with root privileges (Linux) or admin
        # privileges (Windows) the miner configure all MSR registers
        # automatically.
        DynamicUser = lib.mkDefault false;
      };
    };
  };
}
