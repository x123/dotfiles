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
