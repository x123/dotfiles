{ config, pkgs, ... }: {
  imports = [ ];

  #  sops.secrets."postgres/nixium/dbuser" = { };
  #  sops.secrets."postgres/nixium/dbuser".mode = "0400";
  #  sops.secrets."postgres/nixium/dbpass" = { };
  #  sops.secrets."postgres/nixium/dbpass".mode = "0400";

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    enableTCPIP = false;
    ensureDatabases = [ "binrich" ];
    ensureUsers = [
      {
        name = "binrich";
        ensureDBOwnership = true;
        ensureClauses = {
          createdb = true;
        };
      }
    ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  dbuser  auth-method
      local all       all     trust
    '';
    identMap = ''
        # ArbitraryMapName systemUser DBUser
           superuser_map      root      postgres
           superuser_map      postgres  postgres
           # Let other names login as themselves
           superuser_map      /^(.*)$   \1
      	'';
  };

  services.postgresqlBackup = {
    enable = true;
    backupAll = true;
  };
}
