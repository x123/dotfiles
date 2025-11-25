{_, ...}: {
  services = {
    invidious = {
      enable = true;
      database.createLocally = true;
      domain = "hetznix.boxchop.city";
      nginx.enable = true;
      settings = {
        force_resolve = "ipv6";
        statistics_enabled = false;
        registration_enabled = false;
        popular_enabled = false;
        admins = ["x123"];
        decrypt_polling = true; # may use more bandwidth
      };
    };

    # this is needed to disable automatic ACME cert grab from invidious our own
    # definition in security.acme.certs (in acme.nix)
    nginx.virtualHosts = {
      "hetznix.boxchop.city" = {
        enableACME = false;
        useACMEHost = "boxchop.city";
      };
    };

    postgresqlBackup = {
      databases = ["invidious"];
    };
  };
}
