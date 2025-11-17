{config, ...}: {
  # users.users.postfix.extraGroups = ["opendkim"];

  services = {
    n8n = {
      enable = true;
      environment = {
        N8N_SECURE_COOKIE = "false";
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
              tcp dport 5678 counter accept comment "Allow n8n/5678"
            }
          '';
        };
      };
    };
  };
}
