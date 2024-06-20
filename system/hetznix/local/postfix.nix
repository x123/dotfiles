{config, ...}: {
  services.postfix = {
    enable = true;
    enableHeaderChecks = true;
    enableSubmission = true;
    enableSubmissions = true;
    domain = "boxchop.city";
    config = {
      myhostname = "hetznix.boxchop.city";
      myorigin = "boxchop.city";
      relayhost = "";
      inet_protocols = "all";
      # inet_protocols = "ipv4";
      inet_interfaces = "all";
      # inet_interfaces = "loopback-only";
      mydestination = "boxchop.city";
      home_mailbox = "Maildir/";
    };
    sslCert = config.security.acme.certs."boxchop.city".directory + "/full.pem";
    sslKey = config.security.acme.certs."boxchop.city".directory + "/key.pem";
  };
}
