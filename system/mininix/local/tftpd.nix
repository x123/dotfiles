{...}: {
  services = {
    atftpd = {
      enable = true;
      path = "/srv/tftp";
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
              # atftpd
              udp dport 67 counter accept comment "Allow atftpd/67"
              udp dport 68 counter accept comment "Allow atftpd/67"
              udp dport 69 counter accept comment "Allow atftpd/69"
            }
          '';
        };
      };
    };
  };
}
