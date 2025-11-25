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
      };

      # Environment = {
      #   path = [ pkgs.bash ];
      # };

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
