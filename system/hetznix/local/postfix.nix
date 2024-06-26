{
  config,
  pkgs,
  ...
}: {
  users.users.postfix.extraGroups = ["opendkim"];

  services = {
    postfix = {
      enable = true;
      enableHeaderChecks = true;
      enableSubmission = true;
      enableSubmissions = true;
      domain = "boxchop.city";
      config = {
        mydomain = "boxchop.city";
        myhostname = "hetznix.boxchop.city";
        myorigin = "boxchop.city";
        relay_domains = "";
        relayhost = "";
        inet_protocols = "all";
        # inet_protocols = "ipv4";
        inet_interfaces = "all";
        # inet_interfaces = "loopback-only";
        mydestination = "hetznix.boxchop.city social.boxchop.city boxchop.city localhost";
        home_mailbox = "Maildir/";
        milter_default_action = "accept";
        milter_protocol = "2";
        smtpd_milters = "unix:/run/opendkim/opendkim.sock";
        non_smtpd_milters = "unix:/run/opendkim/opendkim.sock";
      };
      sslCert = config.security.acme.certs."boxchop.city".directory + "/full.pem";
      sslKey = config.security.acme.certs."boxchop.city".directory + "/key.pem";
    };

    opendkim = {
      enable = true;
      domains = "csl:boxchop.city,social.boxchop.city,hetznix.boxchop.city";
      selector = "default";
      configFile = pkgs.writeText "opendkim.conf" ''
        UMask 0007
      '';
    };
  };
}