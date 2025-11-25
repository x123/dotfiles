{pkgs, ...}: {
  imports = [];

  systemd.user.timers.gnucash-quotes = {
    Timer = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "3h";
      Unit = "gnucash-quotes.service";
    };
    Install.WantedBy = ["timers.target"];
  };

  systemd.user.services = {
    gnucash-quotes = {
      Unit = {
        Description = "get gnucash quotes";
        Wants = ["network-online.target"];
        After = ["network-online.target" "sops-nix.service"];
        ConditionACPower = true;
      };

      Service = {
        Type = "oneshot";

        # Lower CPU and I/O priority.
        Nice = 19;
        IOSchedulingClass = "best-effort";
        IOSchedulingPriority = 7;
        IOWeight = 100;

        Restart = "no";
        LogRateLimitIntervalSec = 0;

        ExecStartPre =
          pkgs.writeShellScript "sleep-10-seconds"
          ''
            set -euo pipefail
            ${pkgs.coreutils}/bin/sleep 10s
          '';

        ExecStart =
          pkgs.writeShellScript "gnucash-quotes"
          ''
            set -euo pipefail
            ${pkgs.systemd}/bin/systemd-inhibit --who="x" --what="sleep:shutdown" --why="Prevent interrupting scheduled gnucash quote fetch" ${pkgs.gnucash}/bin/gnucash-cli --quotes get /home/x/Dropbox/gnucash/gnucashdb/fm_gnucash.gnucash
          '';
      };
    };
  };
}
