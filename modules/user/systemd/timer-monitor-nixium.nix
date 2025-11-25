{pkgs, ...}: {
  imports = [];

  systemd.user.timers.monitor-nixium = {
    Timer = {
      OnBootSec = "5m";
      AccuracySec = "5s";
      OnUnitActiveSec = "150s";
      Unit = "monitor-nixium.service";
    };
  };

  systemd.user.services = {
    monitor-nixium = {
      Unit = {
        Description = "monitor nixium.boxchop.city";
      };

      Service = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "monitor-nixium"
            ''
              set -euo pipefail

              pushd /home/x/src/gcp-terraform/nixium
              ${pkgs.systemd}/bin/systemd-cat --identifier="monitor-nixium.service" --priority="info" --stderr-priority="err" ${pkgs.sops}/bin/sops exec-env /home/x/src/gcp-terraform/nixium/secrets.yaml '${pkgs.terraform}/bin/terraform plan -compact-warnings -refresh-only -detailed-exitcode -no-color'
              popd
            '';
      };
    };
  };

}
