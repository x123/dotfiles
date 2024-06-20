{_, ...}: {
  services = {
    mastodon = {
      enable = true;
      database.createLocally = true;
      localDomain = "social.boxchop.city";
      configureNginx = true;
      smtp = {
        createLocally = false;
        host = "hetznix.boxchop.city";
        fromAddress = "noreply@social.boxchop.city";
      };
      extraConfig.SINGLE_USER_MODE = "true";
      streamingProcesses = 7;
    };

    # this is needed to disable automatic ACME cert grab from invidious our own
    # definition in security.acme.certs (in acme.nix)
    nginx.virtualHosts = {
      "social.boxchop.city" = {
        enableACME = false;
        useACMEHost = "boxchop.city";
      };
    };

    postgresqlBackup = {
      databases = ["mastodon"];
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
