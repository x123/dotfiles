{
  config,
  lib,
  ...
}: let
  cfg = config.custom;
  trustedIpv4s = builtins.concatStringsSep "," cfg.system-nixos.services.openssh.trustedIpv4Networks;
  trustedIpv6s = builtins.concatStringsSep "," cfg.system-nixos.services.openssh.trustedIpv6Networks;
in {
  options = {
    custom.system-nixos.services.openssh = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to enable the system openssh service";
      };
      openFirewallNftables = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Whether to add nftables rules.";
      };
      trustedIpv4Networks = lib.mkOption {
        default = ["0.0.0.0/0"];
        type = lib.types.listOf lib.types.str;
        description = "Trusted IPv4 ranges to open nftables firewall for.";
      };
      trustedIpv6Networks = lib.mkOption {
        default = ["::/0"];
        type = lib.types.listOf lib.types.str;
        description = "Trusted IPv6 ranges to open nftables firewall for.";
      };
    };
  };

  config = lib.mkIf (cfg.system-nixos.enable && cfg.system-nixos.services.openssh.enable) {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    networking.nftables = lib.mkIf (cfg.system-nixos.services.openssh.openFirewallNftables) {
      tables = {
        filter = {
          family = "inet";
          content = ''
            chain input-new {
              ip6 saddr { ${trustedIpv6s} } tcp dport 22 log prefix "nft-accept-openssh: " level info
              ip6 saddr { ${trustedIpv6s} } tcp dport 22 counter accept

              ip saddr { ${trustedIpv4s} } tcp dport 22 log prefix "nft-accept-openssh: " level info
              ip saddr { ${trustedIpv4s} } tcp dport 22 counter accept
            }'';
        };
      };
    };
  };
}
