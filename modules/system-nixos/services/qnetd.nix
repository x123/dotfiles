{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.system-nixos.services.qnetd;
  trustedIpv4s = builtins.concatStringsSep "," cfg.trustedIpv4Networks;
  trustedIpv6s = builtins.concatStringsSep "," cfg.trustedIpv6Networks;
in {
  options = {
    custom.system-nixos.services.qnetd = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the system qnetd service (for external voting)";
      };
      package = lib.mkOption {
        default = null;
        type = lib.types.package;
        description = "The corosync-qdevice package to use";
      };
      dataDir = lib.mkOption {
        default = "/var/lib/corosync-qnetd";
        type = lib.types.path;
        description = "Path to the writable data directory for qnetd configuration";
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

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.services.qnetd.enable) {
    users.groups.corosync-qnetd = {};
    users.users.corosync-qnetd = {
      isSystemUser = true;
      group = "corosync-qnetd";
      description = "Corosync QNetd daemon user";
    };

    systemd.services.corosync-qnetd = {
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      description = "Corosync QNetd daemon";
      path = [pkgs.nss.tools];
      serviceConfig = {
        ExecStart = "${config.custom.system-nixos.services.qnetd.package}/bin/corosync-qnetd -f";
        Restart = "on-failure";
        StateDirectory = "corosync-qnetd";
        RuntimeDirectory = "corosync-qnetd";
        BindPaths = "${config.custom.system-nixos.services.qnetd.dataDir}:/etc/corosync/qnetd";
        ReadWritePaths = ["/etc/corosync/qnetd"];
        DynamicUser = false;
        User = "corosync-qnetd";
        Group = "corosync-qnetd";
        ExecStartPre = "+${pkgs.writeShellScript "corosync-qnetd-init" ''
          # Fix permissions of existing files
          ${pkgs.coreutils}/bin/chown -R corosync-qnetd:corosync-qnetd /etc/corosync/qnetd

          if [ ! -f /etc/corosync/qnetd/nssdb/cert8.db ] && [ ! -f /etc/corosync/qnetd/nssdb/cert9.db ]; then
            ${config.custom.system-nixos.services.qnetd.package}/bin/corosync-qnetd-certutil -i
            # Fix permissions of newly created files
            ${pkgs.coreutils}/bin/chown -R corosync-qnetd:corosync-qnetd /etc/corosync/qnetd
          fi
        ''}";
      };
    };

    networking.nftables = lib.mkIf cfg.openFirewallNftables {
      tables = {
        filter = {
          family = "inet";
          content = ''
            chain input-new {
              # qnetd
              ${lib.optionalString (cfg.trustedIpv6Networks != []) ''
              ip6 saddr { ${trustedIpv6s} } tcp dport 5403 log prefix "nft-input-accept-qnetd: " level info
              ip6 saddr { ${trustedIpv6s} } tcp dport 5403 counter accept
            ''}

              ${lib.optionalString (cfg.trustedIpv4Networks != []) ''
              ip saddr { ${trustedIpv4s} } tcp dport 5403 log prefix "nft-input-accept-qnetd: " level info
              ip saddr { ${trustedIpv4s} } tcp dport 5403 counter accept
            ''}
            }
          '';
        };
      };
    };
  };
}
