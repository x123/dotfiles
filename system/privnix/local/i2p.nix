{...}: {
  services.i2pd = {
    enable = true;
    bandwidth = 256;
  };
  # networking = {
  #   nftables = {
  #     enable = true; # enable nftables
  #     tables = {
  #       filter = {
  #         family = "inet";
  #         content = ''
  #           chain input-new {
  #             tcp dport 2062 counter accept comment "Allow TCP/2062"
  #           }
  #         '';
  #       };
  #     };
  #   };
  # };
}
