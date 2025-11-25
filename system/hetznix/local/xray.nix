{config, ...}: {
  sops.secrets = {
    "xrayconfig" = {
      mode = "0440";
      # owner = config.users.users.xray.name;
      # group = config.users.users.xray.group;
    };
  };

  services = {
    xray = {
      enable = true;
      settingsFile = config.sops.secrets."xrayconfig".path;
    };

    caddy = {
      enable = true;
      virtualHosts = {
        "x.nixlink.net" = {
          useACMEHost = "nixlink.net";
          extraConfig = ''
            @grpc {
               protocol grpc
               path /heartbeat/* # fill in /YourServiceName/*
             }
             reverse_proxy @grpc unix//dev/shm/Xray-Trojan-gRPC.socket {
               transport http {
                 versions h2c
               }
             }
             root * /var/www/x.nixlink.net
             file_server
          '';
        };
      };
    };
  };

  # networking = {
  #   nftables = {
  #     enable = true;
  #     tables = {
  #       filter = {
  #         family = "inet";
  #         content = ''
  #           chain input-new {
  #             # xray/DNS
  #             tcp dport 443 counter accept comment "Allow TCP/443"
  #           }
  #         '';
  #       };
  #     };
  #   };
  # };
}
