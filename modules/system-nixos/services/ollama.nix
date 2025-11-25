{
  config,
  lib,
  ...
}: let
  cfg = config.custom;
  trustedIpv4s = builtins.concatStringsSep "," cfg.system-nixos.services.ollama.trustedIpv4Networks;
  trustedIpv6s = builtins.concatStringsSep "," cfg.system-nixos.services.ollama.trustedIpv6Networks;
in {
  options = {
    custom.system-nixos.services.ollama = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the system ollama service";
      };
      host = lib.mkOption {
        default = "127.0.0.1";
        type = lib.types.str;
        description = "host for ollama";
      };
      port = lib.mkOption {
        default = 8080;
        type = lib.types.int;
        description = "port for ollama";
      };
      environment = lib.mkOption {
        default = {
        };
        type = lib.types.attrs;
        description = "Extra env vars for ollama";
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

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.services.ollama.enable) {
    networking.nftables = lib.mkIf (cfg.system-nixos.services.ollama.openFirewallNftables) {
      tables = {
        filter = {
          family = "inet";
          content = ''
            chain input-new {
              ip6 saddr { ${trustedIpv6s} } tcp dport ${builtins.toString cfg.system-nixos.services.ollama.port} log prefix "nft-accept-ollama: " level info
              ip6 saddr { ${trustedIpv6s} } tcp dport ${builtins.toString cfg.system-nixos.services.ollama.port} counter accept

              ip saddr { ${trustedIpv4s} } tcp dport ${builtins.toString cfg.system-nixos.services.ollama.port} log prefix "nft-accept-ollama: " level info
              ip saddr { ${trustedIpv4s} } tcp dport ${builtins.toString cfg.system-nixos.services.ollama.port} counter accept
            }'';
        };
      };
    };

    services = {
      ollama = {
        enable = true;
        environmentVariables = cfg.system-nixos.services.ollama.environment;
        host = cfg.system-nixos.services.ollama.host;
        port = cfg.system-nixos.services.ollama.port;
      };
    };
  };
}
