{pkgs, ...}: {
  services.openssh.enable = true;

  # users.groups.git = {};
  #
  # # 2. Create the 'git' user
  # users.users.git = {
  #   isSystemUser = true;
  #   group = "git";
  #   # This must match services.forgejo.stateDir (default is /var/lib/forgejo)
  #   home = "/var/lib/forgejo";
  #   shell = "${pkgs.bash}/bin/bash";
  #   description = "Forgejo Git User";
  # };

  services.forgejo = {
    enable = true;
    database.type = "sqlite3";

    # Run as 'git' so clone URLs are 'git@hostname:...'
    # user = "git";
    # group = "git";

    settings = {
      server = {
        DOMAIN = "forge.empire.internal";
        ROOT_URL = "http://forge.empire.internal/";

        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3000;

        START_SSH_SERVER = false;
        SSH_PORT = 22;
      };

      service = {
        # Set to true AFTER you create your first admin account to prevent others from signing up
        DISABLE_REGISTRATION = false;
      };
    };

    dump = {
      enable = true;
      interval = "04:00"; # Run at 4 AM
      type = "tar.gz";
      file = "forgejo-dump";
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    virtualHosts."forge.empire.internal" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
        # Fix for large git pushes failing over HTTP
        extraConfig = "client_max_body_size 512M;";
      };
    };
  };

  networking.nftables = {
    tables = {
      filter = {
        family = "inet";
        content = ''
          chain input-new {
            ip6 saddr { ::/0 } tcp dport 80 log prefix "nft-accept-http: " level info
            ip6 saddr { ::/0 } tcp dport 80 counter accept

            ip saddr { 0.0.0.0/0 } tcp dport 80 log prefix "nft-accept-http: " level info
            ip saddr { 0.0.0.0/0 } tcp dport 80 counter accept
          }
        '';
      };
    };
  };
}
