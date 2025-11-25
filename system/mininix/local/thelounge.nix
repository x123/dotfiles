{config, ...}: {
  # users.users.postfix.extraGroups = ["opendkim"];

  services = {
    thelounge = {
      enable = true;
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
              # thelounge
              tcp dport 9000 counter accept comment "Allow thelounge/9000"
            }
          '';
        };
      };
    };
  };
}
