{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.system-nixos.services.p2pool;
  trustedIpv4s = builtins.concatStringsSep "," cfg.trustedIpv4Networks;
  trustedIpv6s = builtins.concatStringsSep "," cfg.trustedIpv6Networks;
in {
  options = {
    custom.system-nixos.services.p2pool = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the p2pool service";
      };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/p2pool";
        description = ''
          The directory where p2pool stores its data files.
        '';
      };

      openFirewallNftables = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to add nftables rules for RustDesk ports";
      };

      trustedIpv4Networks = lib.mkOption {
        default = ["0.0.0.0/0"];
        type = lib.types.listOf lib.types.str;
        description = "Trusted IPv4 ranges to open nftables firewall for";
      };

      trustedIpv6Networks = lib.mkOption {
        default = ["::/0"];
        type = lib.types.listOf lib.types.str;
        description = "Trusted IPv6 ranges to open nftables firewall for";
      };

      mini = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the P2Poool mini (true) or Main (false)";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = ''
          The IP address of your Monero node.
        '';
      };

      logLevel = lib.mkOption {
        type = lib.types.ints.between 0 6;
        default = 2;
        description = ''
          Log level for the P2Pool node. (Between 0 - 6)
        '';
      };

      rpcPort = lib.mkOption {
        type = lib.types.port;
        default = 18081;
        description = ''
          Monero daemon RPC API port.
        '';
      };

      zmqPort = lib.mkOption {
        type = lib.types.port;
        default = 18083;
        description = ''
          Monero daemon ZMQ pub port.
        '';
      };

      socks5.enable = lib.mkEnableOption "connecting to a SOCKS5 proxy for outgoing connections";

      socks5.ip = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = ''
          IP address of the SOCKS5 proxy to connect to.
        '';
      };

      socks5.port = lib.mkOption {
        type = lib.types.port;
        default = 9050;
        description = ''
          The port number of the SOCKS5 proxy.
        '';
      };

      walletAddress = lib.mkOption {
        type = lib.types.str;
        default = "$WALLET_ADDRESS";
        description = ''
          The Monero wallet address used for mining payouts.
        '';
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/var/lib/p2pool/p2pool.env";
        description = ''
          Path to an EnvironmentFile for the p2pool service as defined in {manpage}`systemd.exec(5)`.

          Secrets may be passed to the service by specifying placeholder variables in the Nix config
          and setting values in the environment file.

          Example:

          ```
          # In environment file:
          WALLET_ADDRESS=someaddress
          ```

          ```
          # Service config
          services.p2pool.walletAddress = "$WALLET_ADDRESS";
          ```
        '';
      };
    };
  };

  config = lib.mkIf (config.custom.system-nixos.enable && cfg.enable) {
    users.users.p2pool = {
      isSystemUser = true;
      group = "p2pool";
      description = "P2Pool node user";
      home = cfg.dataDir;
      createHome = true;
    };

    users.groups.p2pool = {};

    systemd.sockets.p2pool = {
      description = "P2Pool Command Socket";
      socketConfig = {
        SocketUser = "p2pool";
        SocketGroup = "p2pool";
        ListenFIFO = "/run/p2pool/p2pool.control";
        RemoveOnStop = true;
        DirectoryMode = "0755";
        SocketMode = "0666";
      };
    };

    systemd.services.p2pool = {
      description = "P2Pool node";
      after = [
        "network.target"
        "monero.service"
        "system-modules-load.target"
      ];
      wants = [
        "network.target"
        "monero.service"
        "system-modules-load.target"
      ];
      wantedBy = ["multi-user.target"];
      script =
        ''
          ${lib.getExe pkgs.p2pool} \
            --data-dir ${cfg.dataDir} \
            --rpc-port ${toString cfg.rpcPort} \
            --zmq-port ${toString cfg.zmqPort} \
            --host ${cfg.host} \
        ''
        + "--loglevel ${toString cfg.logLevel}"
        + "${lib.optionalString cfg.mini " \\\n --mini"}"
        + "${lib.optionalString cfg.socks5.enable " \\\n--socks5 ${cfg.socks5.ip}:${toString cfg.socks5.port}"}"
        + "${lib.optionalString (cfg.walletAddress != "") " \\\n--wallet ${cfg.walletAddress}"}";

      serviceConfig = {
        Type = "exec";
        User = "p2pool";
        Group = "p2pool";
        Restart = "always";
        WorkingDirectory = cfg.dataDir;
        TimeoutStop = 60;

        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) [cfg.environmentFile];

        StandardInput = "socket";
        StandardOutput = "journal";
        StandardError = "journal";

        Sockets = ["p2pool.socket"];

        ProtectSystem = "full";
        ProtectHome = true;
        PrivateTmp = "disconnected";
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectProc = "ptraceable";
        ProcSubset = "pid";
        LockPersonality = true;
        RestrictRealtime = true;
        ProtectClock = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        SocketBindDeny = [
          "ipv4:udp"
          "ipv6:udp"
        ];
        CapabilityBoundingSet = [
          "~CAP_BLOCK_SUSPEND"
          "CAP_BPF"
          "CAP_CHOWN"
          "CAP_MKNOD"
          "CAP_NET_RAW"
          "CAP_PERFMON"
          "CAP_SYS_BOOT"
          "CAP_SYS_CHROOT"
          "CAP_SYS_MODULE"
          "CAP_SYS_PACCT"
          "CAP_SYS_PTRACE"
          "CAP_SYS_TIME"
          "CAP_SYSLOG"
          "CAP_WAKE_ALARM"
        ];
        SystemCallFilter = [
          "~@chown:EPERM"
          "@clock:EPERM"
          "@cpu-emulation:EPERM"
          "@debug:EPERM"
          "@keyring:EPERM"
          "@memlock:EPERM"
          "@module:EPERM"
          "@mount:EPERM"
          "@obsolete:EPERM"
          "@pkey:EPERM"
          "@privileged:EPERM"
          "@raw-io:EPERM"
          "@reboot:EPERM"
          "@sandbox:EPERM"
          "@setuid:EPERM"
          "@swap:EPERM"
          "@timer:EPERM"
        ];
      };
    };

    networking.nftables = lib.mkIf cfg.openFirewallNftables {
      tables = {
        filter = {
          family = "inet";
          content = ''
            chain input-new {
              # p2pool
              ip6 saddr { ${trustedIpv6s} } tcp dport { 37888, 37889 } log prefix "nft-input-accept-p2pool-tcp: " level info
              ip6 saddr { ${trustedIpv6s} } tcp dport { 37888, 37889 } counter accept

              ip saddr { ${trustedIpv4s} } tcp dport { 37888, 37889 } log prefix "nft-input-accept-p2pool-tcp: " level info
              ip saddr { ${trustedIpv4s} } tcp dport { 37888, 37889 } counter accept
            }
          '';
        };
      };
    };

    assertions = lib.singleton {
      assertion = cfg.walletAddress != "";
      message = ''
        A wallet address must be specified.
      '';
    };
  };
}
