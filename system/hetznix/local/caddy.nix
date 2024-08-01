{config, ...}: {
  sops.secrets = {
    "caddy/auth/fam" = {
      mode = "0440";
      owner = config.users.users.caddy.name;
      group = config.users.users.caddy.group;
    };
  };

  networking.nftables = {
    tables = {
      filter = {
        family = "inet";
        content = ''
          chain input-new {
            # caddy
            tcp dport { 8880, 8883 } log prefix "nft-input-accept-caddy: " level info
            tcp dport { 8880, 8883 } counter accept
          }
        '';
      };
    };
  };

  services.caddy = {
    enable = true;
    globalConfig = ''
      debug
      http_port 8880
      https_port 8883
    '';
    virtualHosts = {
      "jandf.boxchop.city" = {
        useACMEHost = "boxchop.city";
        extraConfig = ''
          encode zstd gzip
          root * /var/www/jandf.boxchop.city
          file_server
          basic_auth {
            import ${config.sops.secrets."caddy/auth/fam".path}
          }
        '';
      };
    };
  };
}
