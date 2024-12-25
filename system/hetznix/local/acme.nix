{config, ...}: {
  sops.secrets = {
    "DO_AUTH_TOKEN_FILE" = {};
    "CLOUDFLARE_DNS_API_TOKEN_FILE" = {};
  };

  users.users.caddy.extraGroups = ["acme"];

  security.acme = {
    defaults.email = "root@nixlink.net";
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
      "nixlink.net" = {
        group = "acme";
        dnsProvider = "cloudflare";
        email = "root@nixlink.net";
        extraDomainNames = [
          "blockblaster.nixlink.net"
          "hetznix.nixlink.net"
          "ip.nixlink.net"
          "ip6.nixlink.net"
          "kuma.nixlink.net"
          "ntfy.nixlink.net"
          "social.nixlink.net"
        ];
        enableDebugLogs = true;
        credentialFiles = {
          "CLOUDFLARE_DNS_API_TOKEN_FILE" = config.sops.secrets."CLOUDFLARE_DNS_API_TOKEN_FILE".path;
        };
      };
    };
  };
}
