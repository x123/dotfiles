{
  config,
  pkgs,
  ...
}: {
  sops.secrets = {
    "transmission-creds" = {
      mode = "0440";
      owner = "transmission";
      group = "transmission";
    };
  };

  # boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  services = {
    transmission = {
      enable = true;
      package = pkgs.transmission_4;
      # performanceNetParameters = true;
      webHome = pkgs.flood-for-transmission; # for alternate webUI
      credentialsFile = config.sops.secrets."transmission-creds".path;
      settings = {
        download-dir = "/xdata/completed";
        incomplete-dir = "/xdata/downloads";
        incomplete-dir-enabled = true;
        rpc-bind-address = "192.168.1.188";
        # peer-port = XXXX;
        upload-slots-per-torrent = 14; # defaults to 14
        blocklist-url = "https://raw.githubusercontent.com/Naunter/BT_BlockLists/master/bt_blocklists.gz";
        blocklist-enabled = true;
        trash-original-torrent-files = true;
        watch-dir-force-generic = true;
        cache-size-mb = 4; # defaults to 4MB
        dht-enabled = true;
        encryption = 1; # 0 disable, 1 prefer, 2 require
        lpd-enabled = false; # local peer discovery
        pex-enabled = true; # peer exchange
        utp-enabled = true;
        preferred_transport = "utp"; # default "utp", can use "tcp" instead
        bind-address-ipv4 = "10.10.10.9";
        peer-limit-global = 600;
        peer-limit-per-torrent = 150;
        port-forwarding-enabled = false; # disable UPnP / NAT-PMP
        download-queue-enabled = false;
        # download-queue-size = 25; # only used if download-queue-enabled
        seed-queue-enabled = false;
        # seed-queue-size = 30; # only used if seed-queue-enabled
        rpc-authentication-required = true;
        rpc-whitelist-enabled = true;
        rpc-whitelist = "127.0.0.*,192.168.*.*";
        ratio-limit = 2.0;
        ratio-limit-enabled = true;
      };
    };
  };

  networking = {
    nftables = {
      enable = true;
      tables = {
        filter = {
          family = "inet";
          content = ''
            chain input-new {
              # transmission
              udp dport { 27582 } counter accept
              tcp dport { 27582 } counter accept
              ip saddr 192.168.1.0/24 tcp dport { 9091 } counter accept
            }
          '';
        };
      };
    };
  };
}
