{...}: {
  networking = {
    firewall.enable = false; # disable the default firewall
    nftables = {
      enable = true; # enable nftables
      tables = {
        filter = {
          family = "inet";
          content = ''
            chain input-new {
              tcp dport { 80, 443 } log prefix "nft-input-accept-http: " level info
              tcp dport { 80, 443 } counter accept
            }
          '';
        };
      };
    };
  };
}
