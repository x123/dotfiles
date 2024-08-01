{config, ...}: {
  users.users.postfix.extraGroups = ["opendkim"];

  services = {
    dovecot2 = {
      enable = true;
      enableImap = true;
      enableLmtp = false;
      enablePAM = true;
      enablePop3 = false;
      enableQuota = false;
      createMailUser = false;
      showPAMFailure = true;
      sslServerCert = config.security.acme.certs."boxchop.city".directory + "/cert.pem";
      sslServerKey = config.security.acme.certs."boxchop.city".directory + "/key.pem";
      mailLocation = "maildir:~/Maildir";
      extraConfig = ''
        service auth {
          inet_listener {
            address = 127.0.0.1 ::1
            port = 12345
          }
        }
      '';
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
              # IMAP/IMAPS
              tcp dport 143 counter accept comment "Allow IMAP/143"
              tcp dport 993 counter accept comment "Allow IMAPS/993"
            }
          '';
        };
      };
    };
  };
}
