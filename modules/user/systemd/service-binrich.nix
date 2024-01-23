{ pkgs, ... }: {
  imports = [ ];

  systemd.user.services = {
    binrich = {
      Unit = {
        Description = "binrich";
      };

      Service = {
        Type = "exec";
        ExecStart = pkgs.writeShellScript "binrich-fetch"
          ''
            set -euo pipefail


            pushd ~/src/binrich
            ${pkgs.rsync}/bin/rsync -avz root@nixium.boxchop.city:/root/deploy/binrich/data/handyapi.com_responses.txt ~/src/binrich/data/results/handyapi.com_responses.txt
            ${pkgs.rsync}/bin/rsync -avz root@nixium.boxchop.city:/root/deploy/binrich/data/periodic-workstream.txt ~/src/binrich/data/results/periodic-workstream.txt
            ${pkgs.rsync}/bin/rsync -avz root@nixium.boxchop.city:/var/backup/postgresql ~/src/binrich/data/results/
            ${pkgs.rsync}/bin/rsync -avz root@nixium.boxchop.city:/root/deploy/binrich/bin/binrich.log\* ~/src/binrich/data/results/
            popd
          '';
      };
    };
  };

}
