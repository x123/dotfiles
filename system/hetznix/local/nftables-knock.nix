{...}: {
  networking = {
    firewall.enable = false; # disable the default firewall
    nftables = {
      enable = true; # enable nftables
      tables = {
        filter = {
          family = "inet";
          content = ''
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
              set update ip saddr timeout 60m @ks4
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

            chain input-new {
              # pk
              jump pk

              # ssh
              tcp dport 22 ip saddr @ks4 log prefix "nft-input-pn-traffic-accept: " level info
              tcp dport 22 ip saddr @ks4 counter accept
            }
          '';
        };
      };
    };
  };
}
