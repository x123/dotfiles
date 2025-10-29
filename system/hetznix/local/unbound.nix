{config, ...}: {
  # users.users.postfix.extraGroups = ["opendkim"];

  services = {
    unbound = {
      enable = true;
      enableRootTrustAnchor = true;
      checkconf = true; # wont work if settings.remote-control or settings.include are used
      settings = {
        server = {
          interface = ["enp1s0" "lo"];
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
