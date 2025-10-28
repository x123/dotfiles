{config, ...}: {
  sops.secrets = {
    "iodinePass" = {
      mode = "0440";
      owner = config.users.users.iodined.name;
      group = config.users.users.iodined.group;
    };
  };

  services = {
    iodine.server = {
      enable = true;
      domain = "t.nixlink.net";
      ip = "10.42.0.1/24";
      passwordFile = config.sops.secrets."iodinePass".path;
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
              # iodine/DNS
              udp dport 53 counter accept comment "Allow UDP/53"

              iifname "dns0" accept comment "dns0 iodine trusted interface"
            }
          '';
        };
      };
    };
  };
}
