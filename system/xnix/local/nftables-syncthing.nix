{...}: {
  networking = {
    nftables = {
      enable = true; # enable nftables
      tables = {
        filter = {
          family = "inet";
          content = ''
            chain input-new {
              # syncthing
              tcp dport 8384 counter accept comment "Allow syncthing/8384"
              tcp dport 22000 counter accept comment "Allow syncthing-transfer/22000"
              udp dport 22000 counter accept comment "Allow syncthing-transfer/22000"
              udp dport 21027 counter accept comment "Allow syncthing-discovery/21027"
            }
          '';
        };
      };
    };
  };
}
