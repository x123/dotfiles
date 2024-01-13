{ pkgs, ... }: {
  imports = [ ];

  systemd.user.timers.binrich-fetch = {
    Timer = {
      OnBootSec = "5m";
      AccuracySec = "5s";
      OnUnitActiveSec = "150s";
      Unit = "binrich-fetch.service";
    };
    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.services = {
    binrich-fetch = {
      Unit = {
        Description = "binrich fetch";
      };

      Service = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "binrich-fetch"
          ''
            set -euo pipefail


            pushd ~/src/binrich
            ${pkgs.rsync}/bin/rsync -avz root@nixium.boxchop.city:/root/deploy/binrich/data/output.txt ~/src/binrich/data/results/output-from-nixium.txt
            ${pkgs.rsync}/bin/rsync -avz root@nixium.boxchop.city:/root/deploy/binrich/data/workstream.txt ~/src/binrich/data/results/workstream.txt
            ${pkgs.rsync}/bin/rsync -avz root@nixium.boxchop.city:/var/backup/postgresql ~/src/binrich/data/results/
            popd
          '';
      };
    };
  };

}
