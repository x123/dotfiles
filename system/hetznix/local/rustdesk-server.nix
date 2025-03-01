{...}: {
  services.rustdesk-server = {
    enable = true;
    relay.enable = true;
    signal = {
      enable = true;
      relayHosts = ["hetznix.nixlink.net"];
    };
  };

  networking = {
    nftables = {
      enable = true; # enable nftables
      tables = {
        filter = {
          family = "inet";
          content = ''
            chain input-new {
              # rustdesk
              tcp dport {21115, 21116, 21117, 21118, 21119} counter accept comment "Allow rustdesk TCP"
              udp dport 21116 counter accept comment "Allow rustdesk UDP"
            }
          '';
        };
      };
    };
  };
}
