{config, ...}: {
  # users.users.postfix.extraGroups = ["opendkim"];

  services = {
    unbound = {
      enable = true;
      enableRootTrustAnchor = true;
      checkconf = true; # wont work if settings.remote-control or settings.include are used
      settings = {
        server = {
          interface = ["0.0.0.0" "::0"];
          access-control = ["0.0.0.0/0 allow" "::0/0 allow"];
          harden-glue = true;
          harden-dnssec-stripped = true;
          use-caps-for-id = false;
          prefetch = true;
          edns-buffer-size = 1232;
          hide-identity = true;
          hide-version = true;
        };
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
              # unbound
              udp dport 53 counter accept comment "Allow UDP/53 unbound"
              tcp dport 53 counter accept comment "Allow TCP/53 unbound"
              tcp dport 853 counter accept comment "Allow TCP/853 unbound DNS-over-TLS"
            }
          '';
        };
      };
    };
  };
}
