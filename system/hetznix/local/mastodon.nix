{_, ...}: {
  services.mastodon = {
    enable = true;
    database.createLocally = true;
    localDomain = "social.boxchop.city";
    configureNginx = true;
    smtp.fromAddress = "noreply@social.boxchop.city";
    extraConfig.SINGLE_USER_MODE = "true";
    streamingProcesses = 7;
  };

  networking.firewall.allowedTCPPorts = [80 443];

  # this is needed to disable automatic ACME cert grab from invidious our own
  # definition in security.acme.certs (in acme.nix)
  services.nginx.virtualHosts = {
    "social.boxchop.city" = {
      enableACME = false;
      useACMEHost = "boxchop.city";
    };
  };
}
