{
  config,
  pkgs,
  ...
}: {
  imports = [];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    enableTCPIP = true;
    ensureDatabases = [];
    ensureUsers = [];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  dbuser                  auth-method
      local all       all                     trust
      host  all       all    127.0.0.1/32     trust
      host  all       all    ::1/128          trust
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
    databases = [];
    #backupAll = true;
    startAt = "hourly";
  };
}
