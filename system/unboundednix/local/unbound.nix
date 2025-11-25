{
  config,
  inputs,
  lib,
  ...
}: {
  # users.users.unbound.extraGroups = ["acme"];

  services.unbound = {
    enable = true;
    enableRootTrustAnchor = true;

    checkconf = true;

    # Prevents NixOS from forcing 127.0.0.1 into /etc/resolv.conf automatically
    resolveLocalQueries = true;

    settings = {
      server = {
        interface = ["0.0.0.0" "::0"];
        port = 53;
        do-ip4 = "yes";
        do-ip6 = "yes";

        tls-cert-bundle = "/etc/ssl/certs/ca-certificates.crt";
        hide-identity = "yes";
        hide-version = "yes";
        harden-referral-path = "yes";
        harden-dnssec-stripped = "no";

        cache-min-ttl = 300;
        cache-max-ttl = 14400;
        serve-expired = "yes";
        serve-expired-ttl = 3600;
        prefetch = "yes";
        prefetch-key = "yes";
        target-fetch-policy = "\"3 2 1 1 1\"";
        unwanted-reply-threshold = 10000000;
        rrset-cache-size = "256m";
        msg-cache-size = "128m";
        so-rcvbuf = "1m";

        private-domain = "internal.";

        private-address = [
          "192.168.0.0/16"
          "169.254.0.0/16"
          "172.16.0.0/12"
          "10.0.0.0/8"
          "fd00::/8"
          "fe80::/10"
          "fdab:817c:904c::/60"
        ];

        access-control = [
          "192.168.0.0/16 allow"
          "172.16.0.0/12 allow"
          "10.0.0.0/8 allow"
          "127.0.0.1/32 allow"
          "fdab:817c:904c::/60 allow"
        ];
      };

      # --- Forward Zones ---
      forward-zone = [
        {
          name = "internal.";
          forward-tls-upstream = "no";
          forward-first = "no";
          forward-no-cache = "yes";
          forward-addr = "192.168.1.1";
        }
        {
          name = ".";
          forward-tls-upstream = "yes";
          forward-first = "no";
          forward-addr = [
            "116.202.176.26@853#dot.libredns.gr"
            "2a01:4f8:1c0c:8274::1@853#dot.libredns.gr"
          ];
        }
      ];
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
              # unbound
              udp dport 53 counter accept comment "Allow UDP/53 unbound"
              tcp dport 53 counter accept comment "Allow TCP/53 unbound"
              # tcp dport 853 counter accept comment "Allow TCP/853 unbound DNS-over-TLS"
            }
          '';
        };
      };
    };
  };
}
