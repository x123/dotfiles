{config, ...}: {
  #users.users.postfix.extraGroups = ["opendkim"];
  sops.secrets = {
    "MURMUR_ENV" = {
      mode = "0440";
      owner = config.users.users.murmur.name;
      group = config.users.users.murmur.group;
    };
  };

  users.users.murmur.extraGroups = ["acme"];

  services = {
    murmur = {
      enable = true;
      port = 64738;
      environmentFile = config.sops.secrets."MURMUR_ENV".path;
      password = "$MURMURD_PASSWORD";

      sslCert = config.security.acme.certs."nixlink.net".directory + "/cert.pem";
      sslKey = config.security.acme.certs."nixlink.net".directory + "/key.pem";
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
              # Mumble/murmur
              tcp dport 64738 counter accept comment "Allow Mumble/64738"
              udp dport 64738 counter accept comment "Allow Mumble/64738"
            }
          '';
        };
      };
    };
  };
}
