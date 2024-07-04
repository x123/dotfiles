{config, ...}: {
  sops.secrets = {
    "caddy/auth/fam" = {
      mode = "0440";
      owner = config.users.users.caddy.name;
      group = config.users.users.caddy.group;
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
