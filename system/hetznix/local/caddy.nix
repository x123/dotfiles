{...}: {
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
      "ip.boxchop.city" = {
        useACMEHost = "boxchop.city";
        extraConfig = ''
          templates
          header Content-Type text/plain
          respond "{{.RemoteIP}}"
          encode zstd gzip
        '';
      };
    };
  };
}
