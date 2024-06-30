{_, ...}: {
  networking.firewall = {
    enable = false;
    allowedTCPPorts = [22 80 443];
    # extraInputRules = ''
    #   ip saddr { 192.168.1.0/24, 192.168.9.0/24 } tcp dport {22, 9090} accept
    # '';
  };

  networking.nftables = {
    enable = true;
    tables = {
      filter = {
        family = "inet";
        content = ''
          counter cnt_input_drop {
            comment "count all packets that hit the final drop in the input chain"
          }

          counter cnt_rpfilter_drop {
            comment "count all packets that hit the final drop in the rpfilter chain"
          }

          set ks1 {
            type ipv4_addr
            flags timeout
            timeout 10s
            gc-interval 4s
          }
          set ks2 {
            type ipv4_addr
            flags timeout
            timeout 10s
            gc-interval 4s
          }
          set ks3 {
            type ipv4_addr
            flags timeout
            timeout 10s
            gc-interval 4s
          }
          set ks4 {
            type ipv4_addr
            flags timeout
            timeout 60m
            gc-interval 4s
          }

          chain k1 {
            set add ip saddr @ks1
          }
          chain uk1 {
            set update ip saddr timeout 0s @ks1
          }
          chain k2 {
            set update ip saddr timeout 0s @ks1
            set add ip saddr @ks2
          }
          chain uk2 {
            set update ip saddr timeout 0s @ks2
          }
          chain k3 {
            set update ip saddr timeout 0s @ks2
            set add ip saddr @ks3
          }
          chain uk3 {
            set update ip saddr timeout 0s @ks3
          }
          chain k4 {
            set update ip saddr timeout 0s @ks3
            set add ip saddr @ks4 log prefix "nft-pn accepted: " level info
          }

          chain refk {
            set update ip saddr timeout 2m @ks4
          }

          # 8209, 15388, 48665, 49676
          chain pk {
            ct state new ip saddr @ks4 goto refk
            tcp dport 49676 ct state new ip saddr @ks3 goto k4
            tcp dport 48665 ct state new ip saddr @ks3 return
            ip saddr @ks3 ct state new goto uk3
            tcp dport 48665 ct state new ip saddr @ks2 goto k3
            tcp dport 15388 ct state new ip saddr @ks2 return
            ip saddr @ks2 ct state new goto uk2
            tcp dport 15388 ct state new ip saddr @ks1 goto k2
            tcp dport 8209 ct state new ip saddr @ks1 return
            ip saddr @ks1 ct state new goto uk1
            tcp dport 8209 ct state new goto k1
          }

          # ipv6/icmpv6 chain
          chain ipv6 {
              ip6 nexthdr icmpv6 icmpv6 type {
                  destination-unreachable, # type 1
                  packet-too-big, # type 2
                  time-exceeded, # type 3
                  parameter-problem, # type 4
                  echo-request, # type 128
                  echo-reply, # type 129
                  nd-neighbor-solicit,
              } counter accept \
              comment "Accept basic IPv6 functionality"

              ip6 nexthdr icmpv6 icmpv6 type {
                  nd-router-solicit, # type 133
                  nd-router-advert, # type 134
                  nd-neighbor-solicit, # type 135
                  nd-neighbor-advert, # type 136
              } ip6 hoplimit 255 accept \
              comment "Allow IPv6 SLAAC"

              ip6 nexthdr icmpv6 icmpv6 type {
                  mld-listener-query, # type 130
                  mld-listener-report, # type 131
                  mld-listener-reduction, # type 132
                  mld2-listener-report, # type 143
              } ip6 saddr fe80::/10 counter accept \
              comment "Allow IPv6 multicast listener discovery on link-local"

              ip6 saddr fe80::/10 udp sport 547 udp dport 546 accept \
              comment "Accept DHCPv6 replies from IPv6 link-local addresses"

              return

              # possible simplifications
              # icmpv6 type != { nd-redirect, 139 } accept comment "Accept all ICMPv6 messages except redirects and node information queries (type 139).  See RFC 4890, section 4.4."
              # ip6 daddr fe80::/64 udp dport 546 accept comment "DHCPv6 client"
          }

          chain rpfilter {
            type filter hook prerouting priority mangle + 10; policy drop;
            meta nfproto ipv4 udp sport . udp dport { 68 . 67, 67 . 68 } accept comment "DHCPv4 client/server"
            fib saddr . mark . iif oif exists accept
            jump rpfilter-allow
            counter name cnt_rpfilter_drop
          }

          chain rpfilter-allow {
          }

          chain input {
            type filter hook input priority filter; policy drop;

            # loopback interface
            iifname "lo" accept comment "trusted interfaces"

            ct state vmap {
              invalid : jump input-log-drop,
              established : accept,
              related : accept,
              new : jump input-allow,
              untracked : jump input-allow
            }

            udp dport 33434-33523 counter reject comment "Properly reject traceroute UDP requests"
            limit rate 60/minute burst 20 packets log prefix "nft-input-drop: " level info
            counter name cnt_input_drop drop
          }

          chain input-allow {
            # jump to ipv6 chain and return
            jump ipv6

            # pk
            jump pk

            icmp type echo-request counter accept comment "Accept ICMP ping requests"

            # ntp
            udp dport 123 counter accept comment "Allow NTP"

            # ssh
            tcp dport { 22, 8880, 8883 } ip saddr @ks4 log prefix "nft-input-pn-traffic-accept: " level info
            tcp dport { 22, 8880, 8883 } ip saddr @ks4 counter accept

            # http/https
            tcp dport { 80, 443 } log prefix "nft-input-accept-http: " level info
            tcp dport { 80, 443 } counter accept
          }

          chain input-log-drop {
            ct state invalid limit rate 1/second burst 5 packets log prefix "nft-input-drop bad-state-in: " level warn
            ct state invalid counter drop comment "Drop invalid connections"
          }

          # output chain
          chain output {
            type filter hook output priority filter; policy accept;

            # loopback interface
            oifname "lo" accept comment "Always accept loopback"

            ct state vmap {
              invalid : jump output-log-drop,
              established : accept,
              related : accept,
              new : jump output-allow,
              untracked : jump output-allow
            }
          }

          chain output-allow {
            # icmp
            icmp type {echo-request,echo-reply} counter accept comment "Accept ICMP ping requests"

            # icmpv6
            icmpv6 type {echo-request,echo-reply} counter accept comment "Accept ICMPv6 requests"
            # DNS
            tcp dport 53 counter accept comment "Allow DNS on TCP/53"
            udp dport 53 counter accept comment "Allow DNS on UDP/53"

            # NTP
            udp dport 123 counter accept comment "Allow NTP/123"

            # SMTP/SMTPS
            tcp dport 25 ct state new counter accept comment "Allow SMTP/25"
            tcp dport 465 ct state new counter accept comment "Allow SMTPS/465"
          }

          chain output-log-drop {
            ct state invalid limit rate 1/second burst 5 packets log prefix "nft-output-drop bad-state-out: " level warn
            ct state invalid counter drop comment "Drop invalid connections"
          }
        '';
      };
    };
  };
}
