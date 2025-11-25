{
  config,
  lib,
  ...
}: {
  options = {
    custom.system-nixos.services.nftables = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to enable the system nftables service";
      };
    };
  };

  config = lib.mkIf (config.custom.system-nixos.enable && config.custom.system-nixos.services.nftables.enable) {
    networking = {
      firewall.enable = false; # disable the default firewall

      nftables = {
        enable = true;
        flushRuleset = true;
        tables = {
          filter = {
            family = "inet";
            content = ''
              set ipv4_blackhole {
                type ipv4_addr
                flags interval
                auto-merge
                comment "drop all traffic from these hosts"
              }

              set ipv6_blackhole {
                type ipv6_addr
                flags interval
                auto-merge
                comment "drop all traffic from these hosts"
              }

              counter cnt_input_drop {
                comment "count all packets that hit the final drop in the input chain"
              }

              counter cnt_rpfilter_drop {
                comment "count all packets that hit the final drop in the rpfilter chain"
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

                # drop blackholed traffic
                ip saddr @ipv4_blackhole log prefix "nft-input-ipv4-blackhole-drop: " level info
                ip saddr @ipv4_blackhole drop
                ip6 saddr @ipv6_blackhole log prefix "nft-input-ipv6-blackhole-drop: " level info
                ip6 saddr @ipv6_blackhole drop

                ct state vmap {
                  invalid : jump input-log-drop,
                  established : accept,
                  related : accept,
                  new : jump input-new,
                  untracked : jump input-new
                }

                udp dport 33434-33523 counter reject comment "Properly reject traceroute UDP requests"
                limit rate 60/minute burst 20 packets log prefix "nft-input-drop: " level info
                counter name cnt_input_drop drop
              }

              chain input-new {
                # jump to ipv6 chain and return
                jump ipv6

                icmp type echo-request counter accept comment "Accept ICMP ping requests"

                # ntp
                udp dport 123 counter accept comment "Allow NTP"
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
                  new : jump output-new,
                  untracked : jump output-new
                }
              }

              chain output-new {
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
                tcp dport 587 ct state new counter accept comment "Allow SMTPS/587"
              }

              chain output-log-drop {
                ct state invalid limit rate 1/second burst 5 packets log prefix "nft-output-drop bad-state-out: " level info
                ct state invalid counter drop comment "Drop invalid connections"
              }
            '';
          };
        };
      };
    };
  };
}
