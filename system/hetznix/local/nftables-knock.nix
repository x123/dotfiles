{...}: {
  networking = {
    firewall.enable = false; # disable the default firewall
    nftables = {
      enable = true; # enable nftables
      tables = {
        filter = {
          family = "inet";
          content = ''
            set ipv6_ks1 {
              type ipv6_addr
              flags timeout
              timeout 10s
              gc-interval 4s
            }
            set ipv6_ks2 {
              type ipv6_addr
              flags timeout
              timeout 10s
              gc-interval 4s
            }
            set ipv6_ks3 {
              type ipv6_addr
              flags timeout
              timeout 10s
              gc-interval 4s
            }
            set ipv6_ks4 {
              type ipv6_addr
              flags timeout
              timeout 60m
              gc-interval 4s
            }

            chain ipv6_k1 {
              set add ip6 saddr @ipv6_ks1
            }
            chain ipv6_uk1 {
              set update ip6 saddr timeout 0s @ipv6_ks1
            }
            chain ipv6_k2 {
              set update ip6 saddr timeout 0s @ipv6_ks1
              set add ip6 saddr @ipv6_ks2
            }
            chain ipv6_uk2 {
              set update ip6 saddr timeout 0s @ipv6_ks2
            }
            chain ipv6_k3 {
              set update ip6 saddr timeout 0s @ipv6_ks2
              set add ip6 saddr @ipv6_ks3
            }
            chain ipv6_uk3 {
              set update ip6 saddr timeout 0s @ipv6_ks3
            }
            chain ipv6_k4 {
              set update ip6 saddr timeout 0s @ipv6_ks3
              set add ip6 saddr @ipv6_ks4 log prefix "nft-pn accepted: " level info
            }

            chain ipv6_refk {
              set update ip6 saddr timeout 60m @ipv6_ks4
            }

            # 8209, 15388, 48665, 49676
            chain ipv6_pk {
              ct state new ip6 saddr @ipv6_ks4 goto ipv6_refk
              tcp dport 49676 ct state new ip6 saddr @ipv6_ks3 goto ipv6_k4
              tcp dport 48665 ct state new ip6 saddr @ipv6_ks3 return
              ip6 saddr @ipv6_ks3 ct state new goto ipv6_uk3
              tcp dport 48665 ct state new ip6 saddr @ipv6_ks2 goto ipv6_k3
              tcp dport 15388 ct state new ip6 saddr @ipv6_ks2 return
              ip6 saddr @ipv6_ks2 ct state new goto ipv6_uk2
              tcp dport 15388 ct state new ip6 saddr @ipv6_ks1 goto ipv6_k2
              tcp dport 8209 ct state new ip6 saddr @ipv6_ks1 return
              ip6 saddr @ipv6_ks1 ct state new goto ipv6_uk1
              tcp dport 8209 ct state new goto ipv6_k1
            }

            set ipv4_ks1 {
              type ipv4_addr
              flags timeout
              timeout 10s
              gc-interval 4s
            }
            set ipv4_ks2 {
              type ipv4_addr
              flags timeout
              timeout 10s
              gc-interval 4s
            }
            set ipv4_ks3 {
              type ipv4_addr
              flags timeout
              timeout 10s
              gc-interval 4s
            }
            set ipv4_ks4 {
              type ipv4_addr
              flags timeout
              timeout 60m
              gc-interval 4s
            }

            chain ipv4_k1 {
              set add ip saddr @ipv4_ks1
            }
            chain ipv4_uk1 {
              set update ip saddr timeout 0s @ipv4_ks1
            }
            chain ipv4_k2 {
              set update ip saddr timeout 0s @ipv4_ks1
              set add ip saddr @ipv4_ks2
            }
            chain ipv4_uk2 {
              set update ip saddr timeout 0s @ipv4_ks2
            }
            chain ipv4_k3 {
              set update ip saddr timeout 0s @ipv4_ks2
              set add ip saddr @ipv4_ks3
            }
            chain ipv4_uk3 {
              set update ip saddr timeout 0s @ipv4_ks3
            }
            chain ipv4_k4 {
              set update ip saddr timeout 0s @ipv4_ks3
              set add ip saddr @ipv4_ks4 log prefix "nft-pn accepted: " level info
            }

            chain ipv4_refk {
              set update ip saddr timeout 60m @ipv4_ks4
            }

            # 8209, 15388, 48665, 49676
            chain ipv4_pk {
              ct state new ip saddr @ipv4_ks4 goto ipv4_refk
              tcp dport 49676 ct state new ip saddr @ipv4_ks3 goto ipv4_k4
              tcp dport 48665 ct state new ip saddr @ipv4_ks3 return
              ip saddr @ipv4_ks3 ct state new goto ipv4_uk3
              tcp dport 48665 ct state new ip saddr @ipv4_ks2 goto ipv4_k3
              tcp dport 15388 ct state new ip saddr @ipv4_ks2 return
              ip saddr @ipv4_ks2 ct state new goto ipv4_uk2
              tcp dport 15388 ct state new ip saddr @ipv4_ks1 goto ipv4_k2
              tcp dport 8209 ct state new ip saddr @ipv4_ks1 return
              ip saddr @ipv4_ks1 ct state new goto ipv4_uk1
              tcp dport 8209 ct state new goto ipv4_k1
            }

            chain input-new {
              # pk
              jump ipv4_pk
              jump ipv6_pk

              # ssh
              tcp dport 22 ip saddr @ipv4_ks4 log prefix "nft-input-pn-traffic-ssh-accept: " level info
              tcp dport 22 ip saddr @ipv4_ks4 counter accept
              tcp dport 22 ip6 saddr @ipv6_ks4 log prefix "nft-input-pn-traffic-ssh-accept: " level info
              tcp dport 22 ip6 saddr @ipv6_ks4 counter accept

              # crusader
              tcp dport 35481 ip saddr @ipv4_ks4 log prefix "nft-input-pn-traffic-crusader-accept: " level info
              tcp dport 35481 ip saddr @ipv4_ks4 counter accept
              tcp dport 35481 ip6 saddr @ipv6_ks4 log prefix "nft-input-pn-traffic-crusader-accept: " level info
              tcp dport 35481 ip6 saddr @ipv6_ks4 counter accept

              # crusader udp
              udp dport 35481 ip saddr @ipv4_ks4 log prefix "nft-input-pn-traffic-crusader-accept: " level info
              udp dport 35481 ip saddr @ipv4_ks4 counter accept
              udp dport 35481 ip6 saddr @ipv6_ks4 log prefix "nft-input-pn-traffic-crusader-accept: " level info
              udp dport 35481 ip6 saddr @ipv6_ks4 counter accept
            }
          '';
        };
      };
    };
  };
}
