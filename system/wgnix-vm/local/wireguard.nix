{config, ...}: {
  sops.secrets = {
    "wireguard/config" = {
      mode = "0440";
      owner = "systemd-network";
      group = "systemd-network";
    };
    "wireguard/privkey" = {
      mode = "0440";
      owner = "systemd-network";
      group = "systemd-network";
    };
    "wireguard/presharedkey" = {
      mode = "0440";
      owner = "systemd-network";
      group = "systemd-network";
    };
    "wireguard/publickey" = {
      mode = "0440";
      owner = "systemd-network";
      group = "systemd-network";
    };
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  systemd.network = {
    networks."50-wg0" = {
      matchConfig.Name = "wg0";
      address = [
        "10.183.199.88/32"
      ];
    };

    netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."wireguard/privkey".path;
        RouteTable = "main";
        FirewallMark = 42;
      };
      wireguardPeers = [
        {
          PublicKeyFile = config.sops.secrets."wireguard/publickey".path;
          PresharedKeyFile = config.sops.secrets."wireguard/presharedkey".path;
          AllowedIPs = [
            "0.0.0.0/0"
          ];
          Endpoint = "ch3.vpn.airdns.org:1637";
        }
      ];
    };
  };

  networking = {
    nftables = {
      enable = true;
      tables = {
        nat = {
          family = "inet";
          content = ''
            chain prerouting {
              type nat hook prerouting priority -100;
              iifname "wg0" tcp dport 39272 counter dnat ip to 10.10.10.6
              iifname "wg0" udp dport 39272 counter dnat ip to 10.10.10.6
            }

            chain postrouting {
              # this hook runs just before packets leave the server
              type nat hook postrouting priority 100; # policy accept;

              ip saddr 10.10.10.0/24 oifname "wg0" counter masquerade
            }
          '';
        };
        filter = {
          family = "inet";
          content = ''
            # this table filters packets passing *through* the server.
            chain forward {
              type filter hook forward priority 0;

              # by default drop all forwarded traffic for security
              policy drop;

              # established/related
              ct state related,established counter accept

              iifname "ens19" oifname "wg0" counter accept comment "Allow in ens19 and out wg0"
              iifname "wg0" oifname "ens19" counter accept comment "Allow in wg0 and out ens19"
              limit rate 60/minute burst 20 packets log prefix "nft-forward-drop: " level info
            }
          '';
        };
      };
    };
  };
}
