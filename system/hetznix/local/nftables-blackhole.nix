{...}: {
  networking = {
    firewall.enable = false; # disable the default firewall
    nftables = {
      enable = true; # enable nftables
      tables = {
        filter = {
          family = "inet";
          content = ''
            set ipv4_blackhole {
              type ipv4_addr
              flags interval
              auto-merge
              comment "drop all traffic from these hosts"
              # elements = {
              #   87.120.93.10,
              # }
            }
          '';
        };
      };
    };
  };
}
