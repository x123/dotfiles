{ pkgs, flake-inputs, ... }:

let
  binrich-release = flake-inputs.binrich.packages.${pkgs.stdenv.hostPlatform.system}.binrich;
  bash = pkgs.bash;
  #binrich-release = flake-inputs.binrich.packages.${pkgs.stdenv.hostPlatform.system}.binrich;
  br = "br";
  working_directory = "/home/binrich";
in
{
  systemd.user.services = {
    binrich = {
      Unit = {
        Description = "binrich";
        # systemctl --user can't depend on any system services
        # WantedBy = [ "multi-user.target" ];
        # After = ["network.target" "postgresql.service" ];
        # Requires = ["network-online.target" "postgresql.service" ];
      };

      Service = {
        Type = "exec";
        WorkingDirectory = working_directory;
        DynamicUser = false;
        PrivateTmp = true;
        ExecStart = pkgs.writeShellScript "binrich-start"
          ''
            set -euo pipefail
            eval $(${pkgs.coreutils}/bin/cat /run/secrets/postgres/nixium/binrichfile) ${binrich-release}/bin/binrich start
          '';
        ExecStop = pkgs.writeShellScript "binrich-stop"
          ''
            set -euo pipefail
            eval $(${pkgs.coreutils}/bin/cat /run/secrets/postgres/nixium/binrichfile) ${binrich-release}/bin/binrich stop
          '';
        ExecReload = pkgs.writeShellScript "binrich-restart"
          ''
            set -euo pipefail
            eval $(${pkgs.coreutils}/bin/cat /run/secrets/postgres/nixium/binrichfile) ${binrich-release}/bin/binrich restart
          '';
      };
    };
  };
}
