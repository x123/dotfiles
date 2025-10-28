{...}: {
  services.i2pd = {
    enable = true;
    bandwidth = 256;
    address = "192.168.1.151";
    proto = {
      http = {
        enable = true;
        hostname = "privnix.empire.internal";
        address = "192.168.1.151";
      };
      socksProxy = {
        enable = true;
        address = "192.168.1.151";
      };
      httpProxy = {
        enable = true;
        address = "192.168.1.151";
      };
      sam = {
        enable = true;
        address = "192.168.1.151";
      };
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
              tcp dport 7655 counter accept comment "Allow i2pd.unk/7655"
              tcp dport 7656 counter accept comment "Allow i2pd.sam/7656"
              tcp dport 7070 counter accept comment "Allow i2pd.web/7070"
              tcp dport 4447 counter accept comment "Allow i2pd.socksproxy/4447"
              tcp dport 4444 counter accept comment "Allow i2pd.httpproxy/4444"
            }
          '';
        };
      };
    };
  };
}
