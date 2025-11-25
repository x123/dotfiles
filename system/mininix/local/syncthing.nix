{config, ...}: {
  # users.users.postfix.extraGroups = ["opendkim"];

  sops.secrets = {
    "syncthing-gui-pass" = {
      mode = "0400";
      owner = config.users.users.syncthing.name;
      group = config.users.users.syncthing.group;
    };
  };

  services = {
    syncthing = {
      enable = true;
      guiAddress = "0.0.0.0:8384";
      guiPasswordFile = config.sops.secrets."syncthing-gui-pass".path;
      settings = {
        gui = {
          user = "x";
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
              # syncthing
              tcp dport 8384 counter accept comment "Allow syncthing/8384"
              tcp dport 22000 counter accept comment "Allow syncthing-transfer/22000"
              udp dport 22000 counter accept comment "Allow syncthing-transfer/22000"
              udp dport 21027 counter accept comment "Allow syncthing-discovery/21027"
            }
          '';
        };
      };
    };
  };
}
