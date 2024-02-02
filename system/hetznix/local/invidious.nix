{config, ...}: {
  sops.secrets = {
    "DO_AUTH_TOKEN_FILE" = {};
  };

  services.invidious = {
    enable = true;
    database.createLocally = true;
    domain = "hetznix.boxchop.city";
    nginx.enable = true;
    settings = {
      statistics_enabled = false;
      registration_enabled = false;
      popular_enabled = false;
      admins = ["x123"];
      decrypt_polling = true; # may use more bandwidth
    };
  };

  # this is needed to disable automatic ACME cert grab from invidious and use
  # our own definition in securite.acme.certs below
  services.nginx.virtualHosts = {
    "hetznix.boxchop.city" = {
      enableACME = false;
      useACMEHost = "boxchop.city";
    };
  };
  users.users.nginx.extraGroups = ["acme"];

  security.acme = {
    defaults.email = "root@boxchop.city";
    acceptTerms = true;
    certs = {
      "boxchop.city" = {
        group = "acme";
        dnsProvider = "digitalocean";
        email = "root@boxchop.city";
        extraDomainNames = ["hetznix.boxchop.city"];
        enableDebugLogs = true;
        credentialFiles = {
          "DO_AUTH_TOKEN_FILE" = config.sops.secrets."DO_AUTH_TOKEN_FILE".path;
        };
      };
    };
  };
}
