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
              # tcp dport 12865 log prefix "nft-input-accept-netperf: " level info
              # tcp dport 12865 counter accept
              # tcp dport {7, 9, 19} log prefix "nft-input-accept-netperf: " level info
              # tcp dport {7, 9, 19} counter accept
              # udp dport {7, 9, 19} log prefix "nft-input-accept-netperf: " level info
              # udp dport {7, 9, 19} counter accept
            }
          '';
        };
      };
    };
  };
}
