{
  config,
  lib,
  pkgs,
  ...
}: let
  trustedIpv4s = builtins.concatStringsSep "," config.custom.system-nixos.services.xmrig-proxy.trustedIpv4Networks;
  trustedIpv6s = builtins.concatStringsSep "," config.custom.system-nixos.services.xmrig-proxy.trustedIpv6Networks;
in {
  options = {
    custom.system-nixos.services.xmrig-proxy = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the system xmrig-proxy service";
      };
      package = lib.mkPackageOption pkgs "xmrig-proxy" {
        example = "xmrig-proxy";
      };
      configFile = lib.mkOption {
        default = null;
        type = lib.types.str;
        description = "path to config file";
      };
      openFirewallNftables = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to add nftables rules.";
      };
      trustedIpv4Networks = lib.mkOption {
        default = ["127.0.0.1/32"];
        type = lib.types.listOf lib.types.str;
        description = "Trusted IPv4 ranges to open nftables firewall for.";
      };
      trustedIpv6Networks = lib.mkOption {
        default = ["::1/128"];
        type = lib.types.listOf lib.types.str;
        description = "Trusted IPv6 ranges to open nftables firewall for.";
      };
    };
  };

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.services.xmrig-proxy.enable) {
    systemd.services.xmrig-proxy = {
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      description = "xmrig-proxy service";
      serviceConfig = {
        LoadCredential = ["xmrig-proxy.json:${config.custom.system-nixos.services.xmrig-proxy.configFile}"];
        ExecStart = "${lib.getExe config.custom.system-nixos.services.xmrig-proxy.package} --config=\${CREDENTIALS_DIRECTORY}/xmrig-proxy.json";
        # if Load credential doesn't work use below
        # ExecStart = "${lib.getExe config.custom.system-nixos.services.xmrig-proxy.package} --config=${config.custom.system-nixos.services.xmrig-proxy.configFile}";
        DynamicUser = lib.mkDefault true;

        # Isolate the service from the rest of the filesystem
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = ["AF_INET" "AF_INET6"];

        # Prevent gaining new privileges
        NoNewPrivileges = true;

        # Since we don't mine, we don't need memory locking or high priority
        LimitMEMLOCK = "64M";
      };
    };

    networking.nftables = lib.mkIf (config.custom.system-nixos.services.xmrig-proxy.openFirewallNftables) {
      tables = {
        filter = {
          family = "inet";
          content = ''
            chain input-new {
              # xmrig
              ip6 saddr { ${trustedIpv6s} } tcp dport 3333 log prefix "nft-input-accept-xmrig-proxy: " level info
              ip6 saddr { ${trustedIpv6s} } tcp dport 3333 counter accept

              ip saddr { ${trustedIpv4s} } tcp dport 3333 log prefix "nft-input-accept-xmrig-proxy: " level info
              ip saddr { ${trustedIpv4s} } tcp dport 3333 counter accept
            }
          '';
        };
      };
    };
  };
}
