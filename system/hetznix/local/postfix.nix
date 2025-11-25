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
      extraConfig = ''
        smtpd_recipient_restrictions =
          reject_rbl_client zen.spamhaus.org=127.0.0.[2..11]
          reject_rhsbl_sender dbl.spamhaus.org=127.0.1.[2..99]
          reject_rhsbl_helo dbl.spamhaus.org=127.0.1.[2..99]
          reject_rhsbl_reverse_client dbl.spamhaus.org=127.0.1.[2..99]
          warn_if_reject reject_rbl_client zen.spamhaus.org=127.255.255.[1..255]

        # Reject the request if the sender is the null address and there are multiple recipients
        smtpd_data_restrictions = reject_multi_recipient_bounce

        # Sender Restrictions
        smtpd_sender_restrictions =
          reject_non_fqdn_sender
          reject_unknown_sender_domain
          reject_unauthenticated_sender_login_mismatch
      '';
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
