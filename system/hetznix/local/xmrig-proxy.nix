{config, ...}: {
  sops.secrets = {
    "xmrig-proxy-conf" = {
      # mode = "0444";
    };

    "p2pool-env" = {
      owner = config.users.users.p2pool.name;
      group = config.users.users.p2pool.group;
    };
  };

  services.monero = {
    enable = true;
    mining.enable = false;
    extraConfig = ''
      enable-dns-blocklist=1
      enforce-dns-checkpointing=1
      in-peers=64
      out-peers=32
      prune-blockchain=1
      zmq-pub=tcp://127.0.0.1:18083
    '';
    priorityNodes = [
      "p2pmd.xmrvsbeast.com:18080"
      "nodes.hashvault.pro:18080"
    ];
  };

  networking = {
    nftables = {
      enable = true; # enable nftables
      tables = {
        filter = {
          family = "inet";
          content = ''
            chain input-new {
              # monero
              tcp dport 18080 counter accept comment "Allow Monero/18080"
            }
          '';
        };
      };
    };
  };

  custom.system-nixos = {
    enable = true;

    services = {
      p2pool = {
        enable = true;
        openFirewallNftables = true;
        environmentFile = config.sops.secrets."p2pool-env".path;
        mini = true;
      };

      xmrig-proxy = {
        enable = true;
        configFile = config.sops.secrets."xmrig-proxy-conf".path;
        openFirewallNftables = true;
        trustedIpv4Networks = ["0.0.0.0/0"];
        trustedIpv6Networks = ["::/0"];
      };
    };
  };
}
