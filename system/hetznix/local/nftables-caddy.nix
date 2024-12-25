{...}: {
  networking.nftables = {
    tables = {
      filter = {
        family = "inet";
        content = ''
          chain input-new {
            # caddy
            tcp dport { 80, 443 } log prefix "nft-input-accept-http-caddy: " level info
            tcp dport { 80, 443 } counter accept
          }
        '';
      };
    };
  };
}
