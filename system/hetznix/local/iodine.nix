{config, ...}: {
  sops.secrets = {
    "iodinePass" = {
      mode = "0440";
      owner = config.users.users.iodined.name;
      group = config.users.users.iodined.group;
    };
  };

  services = {
    iodine.server = {
      enable = true;
      domain = "t.nixlink.net";
      ip = "10.42.0.1/24";
      passwordFile = config.sops.secrets."iodinePass".path;
    };
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking = {
    nftables = {
      enable = true;
      tables = {
        nat = {
          family = "inet";
          content = ''
            chain postrouting {
              # this hook runs just before packets leave the server
              type nat hook postrouting priority 100; policy accept;

              # if the traffic source is the iodine subnet (10.42.0.0/24) and
              # is leaving the main interface, masquerade.
              ip saddr 10.42.0.0/24 oifname "enp1s0" masquerade
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

              # Block QUIC (HTTP/3) so clients gracefully fallback to TCP/443
              # iifname "dns0" oifname "enp1s0" udp dport 443 reject with icmp type admin-prohibited

              # Static MSS clamp
              # Clamp the client's initial SYN packet
              # iifname "dns0" oifname "enp1s0" tcp flags syn tcp option maxseg size set 1090
              # Clamp the server's SYN-ACK reply packet
              # iifname "enp1s0" oifname "dns0" tcp flags (syn | ack) tcp option maxseg size set 1090

              # MSS dynamic clamp style
              # clamp MSS for traffic coming *from* the tunnel
              iifname "dns0" oifname "enp1s0" tcp flags syn tcp option maxseg size set rt mtu
              # clamp MSS for traffic going *into* the tunnel
              iifname "enp1s0" oifname "dns0" tcp flags (syn | ack) tcp option maxseg size set rt mtu

              # established/related
              ct state related,established accept

              # allow from the iodine tunnel ('dns0') and out to the internet
              # ('enp1s0')
              iifname "dns0" oifname "enp1s0" accept comment "Allow in dns0 and out enp1s0"
            }
            chain input-new {
              # iodine/DNS
              udp dport 53 counter accept comment "Allow UDP/53"

              iifname "dns0" accept comment "Allow in dns0 iodine trusted interface"
            }
          '';
        };
      };
    };
  };
}
