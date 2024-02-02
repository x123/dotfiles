{
  config,
  options,
  ...
}: {
  sops.secrets = {
    "maddy/root@boxchop.city" = {
      mode = "0400";
      owner = "maddy";
    };

    "maddy/postmaster@boxchop.city" = {
      mode = "0400";
      owner = "maddy";
    };
  };

  users.users.maddy.extraGroups = ["acme"];

  services.maddy = {
    enable = true;
    openFirewall = true;

    primaryDomain = config.networking.fqdn;
    hostname = config.networking.fqdn;

    tls = {
      loader = "file";
      certificates = [
        {
          keyPath = config.security.acme.certs."boxchop.city".directory + "/key.pem";
          certPath = config.security.acme.certs."boxchop.city".directory + "/cert.pem";
        }
      ];
    };

    ensureAccounts = [
      "root@boxchop.city"
      "postmaster@boxchop.city"
    ];

    ensureCredentials = {
      "root@boxchop.city".passwordFile = config.sops.secrets."maddy/root@boxchop.city".path;
      "postmaster@boxchop.city".passwordFile = config.sops.secrets."maddy/postmaster@boxchop.city".path;
    };

    # Enable TLS listeners. Configuring this via the module is not yet
    # implemented, see https://github.com/NixOS/nixpkgs/pull/153372
    config =
      builtins.replaceStrings [
        "imap tcp://0.0.0.0:143"
        "submission tcp://0.0.0.0:587"
      ] [
        "imap tls://0.0.0.0:993 tcp://0.0.0.0:143"
        "submission tls://0.0.0.0:465 tcp://0.0.0.0:587"
      ]
      options.services.maddy.config.default;
  };

  # Opening ports for additional TLS listeners. This is not yet
  # implemented in the module.
  networking.firewall.allowedTCPPorts = [993 465];
}
