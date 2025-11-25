{config, ...}: {
  sops.secrets = {
    "DO_AUTH_TOKEN_FILE" = {};
  };

  users.users.caddy.extraGroups = ["acme"];

  security.acme = {
    defaults.email = "root@boxchop.city";
    acceptTerms = true;
    certs = {
      "boxchop.city" = {
        group = "acme";
        dnsProvider = "digitalocean";
        email = "root@boxchop.city";
        extraDomainNames = [
          "blockblaster.boxchop.city"
          "hetznix.boxchop.city"
          "ip.boxchop.city"
          "ip6.boxchop.city"
          "kuma.boxchop.city"
          "ntfy.boxchop.city"
          "social.boxchop.city"
        ];
        enableDebugLogs = true;
        credentialFiles = {
          "DO_AUTH_TOKEN_FILE" = config.sops.secrets."DO_AUTH_TOKEN_FILE".path;
        };
      };
    };
  };
}
