{config, ...}: {
  services.invidious = {
    enable = true;
    database.createLocally = true;
    domain = "hetznix.boxchop.city";
    nginx.enable = true;
    settings = {
      registration_enabled = false;
    };
  };

  security.acme = {
    defaults.email = "root@boxchop.city";
    acceptTerms = true;
  };

  # networking.firewall.allowedTCPPorts = [config.services.invidious.port];
}
