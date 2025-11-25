{...}: {
  services.caddy = {
    enable = true;
    virtualHosts = {
      "blockblaster.nixlink.net" = {
        useACMEHost = "nixlink.net";
        extraConfig = ''
          root * /var/www/blockblaster.nixlink.net
          encode zstd gzip
          redir /play /v0.1.34/blockblaster.html
          file_server
        '';
      };
    };
  };
}
