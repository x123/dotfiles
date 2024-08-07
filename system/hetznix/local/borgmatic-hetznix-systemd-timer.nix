{pkgs, ...}: {
  imports = [];

  # nixpkgs.overlays = [
  #   (
  #     final: prev: {
  #       unstable-small = import inputs.nixpkgs-unstable-small {
  #         system = "x86_64-linux";
  #       };
  #     }
  #   )
  # ];

  systemd.timers.borgmatic.enable = false;
  systemd.services.borgmatic.enable = false;

  systemd.timers.borgmatic-hetznix = {
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "3h";
      Unit = "borgmatic-hetznix.service";
    };
    wantedBy = ["timers.target"];
  };

  systemd.services = {
    borgmatic-hetznix = {
      enable = true;
      after = ["network-online.target" "sops-nix.service"];
      description = "run borgmatic backup";
      wants = ["network-online.target"];
      # Unit = {
      #   ConditionACPower = true;
      # };

      serviceConfig = {
        Type = "oneshot";
        LockPersonality = true;
        MemoryDenyWriteExecute = "no";
        NoNewPrivileges = "yes";
        PrivateDevices = "yes";
        PrivateTmp = "yes";
        ProtectClock = "yes";
        ProtectControlGroups = "yes";
        ProtectHostname = "yes";
        ProtectKernelLogs = "yes";
        ProtectKernelModules = "yes";
        ProtectKernelTunables = "yes";
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
        RestrictNamespaces = "yes";
        RestrictRealtime = "yes";
        RestrictSUIDSGID = "yes";
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
        SystemCallErrorNumber = "EPERM";
        # To restrict write access further, change "ProtectSystem" to "strict" and
        # uncomment "ReadWritePaths", "TemporaryFileSystem", "BindPaths" and
        # "BindReadOnlyPaths". Then add any local repository paths to the list of
        # "ReadWritePaths". This leaves most of the filesystem read-only to borgmatic.
        ProtectSystem = "full";
        # ReadWritePaths=-/mnt/my_backup_drive
        # This will mount a tmpfs on top of /root and pass through needed paths
        # TemporaryFileSystem=/root:ro
        # BindPaths=-/root/.cache/borg -/root/.config/borg -/root/.borgmatic
        # BindReadOnlyPaths=-/root/.ssh

        # May interfere with running external programs within borgmatic hooks.
        CapabilityBoundingSet = "CAP_DAC_READ_SEARCH CAP_NET_RAW";

        # Lower CPU and I/O priority.
        Nice = 19;
        CPUSchedulingPolicy = "batch";
        IOSchedulingClass = "best-effort";
        IOSchedulingPriority = 7;
        IOWeight = 100;

        Restart = "no";
        # Prevent rate limiting of borgmatic log events. If you are using an older version of systemd that
        # doesn't support this (pre-240 or so), you may have to remove this option.
        LogRateLimitIntervalSec = 0;

        ExecStartPre =
          pkgs.writeShellScript "sleep-10-seconds"
          ''
            set -euo pipefail
            ${pkgs.coreutils}/bin/sleep 10s
          '';

        ExecStart =
          pkgs.writeShellScript "borgmatic-hetznix"
          ''
            set -euo pipefail
            ${pkgs.systemd}/bin/systemd-inhibit --who="root" --what="sleep:shutdown" --why="Prevent interrupting scheduled backup" ${pkgs.borgmatic}/bin/borgmatic --verbosity -2 --syslog-verbosity 2
          '';
      };
    };
  };
}
