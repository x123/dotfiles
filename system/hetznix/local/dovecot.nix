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
}
