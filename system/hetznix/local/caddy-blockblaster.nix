{...}: {
  services.caddy = {
    enable = true;
    virtualHosts = {
      "blockblaster.boxchop.city" = {
        useACMEHost = "boxchop.city";
        extraConfig = ''
          root * /var/www/blockblaster.boxchop.city
          encode zstd gzip
          redir /play /v0.1.34/blockblaster.html
          file_server
        '';
      };
    };
  };
}
