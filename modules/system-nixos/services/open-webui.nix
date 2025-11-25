{
  config,
  lib,
  ...
}: let
  trustedIpv4s = builtins.concatStringsSep "," config.custom.system-nixos.services.open-webui.trustedIpv4Networks;
  trustedIpv6s = builtins.concatStringsSep "," config.custom.system-nixos.services.open-webui.trustedIpv6Networks;
in {
  options = {
    custom.system-nixos.services.open-webui = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the system open-webui service";
      };
      host = lib.mkOption {
        default = "127.0.0.1";
        type = lib.types.str;
        description = "host for open-webui";
      };
      port = lib.mkOption {
        default = 8080;
        type = lib.types.int;
        description = "port for open-webui";
      };
      environment = lib.mkOption {
        default = {
          ANONYMIZED_TELEMETRY = "False";
          DO_NOT_TRACK = "True";
          SCARF_NO_ANALYTICS = "True";
          # WEBUI_AUTH = "False";
          OLLAMA_BASE_URL = "http://127.0.0.1:11434";
        };
        type = lib.types.attrs;
        description = "Extra env vars for open-webui";
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

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.services.open-webui.enable) {
    networking.nftables = lib.mkIf (config.custom.system-nixos.services.open-webui.openFirewallNftables) {
      tables = {
        filter = {
          family = "inet";
          content = ''
            chain input-new {
              ip6 saddr { ${trustedIpv6s} } tcp dport ${builtins.toString config.custom.system-nixos.services.open-webui.port} log prefix "nft-accept-open-webui: " level info
              ip6 saddr { ${trustedIpv6s} } tcp dport ${builtins.toString config.custom.system-nixos.services.open-webui.port} counter accept

              ip saddr { ${trustedIpv4s} } tcp dport ${builtins.toString config.custom.system-nixos.services.open-webui.port} log prefix "nft-accept-open-webui: " level info
              ip saddr { ${trustedIpv4s} } tcp dport ${builtins.toString config.custom.system-nixos.services.open-webui.port} counter accept
            }'';
        };
      };
    };

    services = {
      open-webui = {
        enable = true;
        environment = config.custom.system-nixos.services.open-webui.environment;
        host = config.custom.system-nixos.services.open-webui.host;
        port = config.custom.system-nixos.services.open-webui.port;
      };
    };
  };
}
