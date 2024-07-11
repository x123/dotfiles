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
      rootAlias = "x123";
      domain = "boxchop.city";
      config = {
        # inet_interfaces = "loopback-only";
        # inet_protocols = "ipv4";
        home_mailbox = "Maildir/";
        inet_interfaces = "all";
        inet_protocols = "all";
        milter_default_action = "accept";
        milter_protocol = "2";
        mydestination = "hetznix.boxchop.city social.boxchop.city boxchop.city localhost";
        mydomain = "boxchop.city";
        myhostname = "hetznix.boxchop.city";
        myorigin = "boxchop.city";
        non_smtpd_milters = "unix:/run/opendkim/opendkim.sock";
        propagate_unmatched_extension = "";
        recipient_delimiter = "+";
        relay_domains = "";
        relayhost = "";
        smtpd_milters = "unix:/run/opendkim/opendkim.sock";
        smtpd_sasl_path = "inet:127.0.0.1:12345";
        smtpd_sasl_type = "dovecot";
      };
      submissionOptions = {
        milter_macro_daemon_name = "ORIGINATING";
        smtpd_client_restrictions = "permit_sasl_authenticated,reject";
        smtpd_sasl_path = "inet:127.0.0.1:12345";
        smtpd_sasl_auth_enable = "yes";
        smtpd_sasl_type = "dovecot";
        smtpd_tls_security_level = "encrypt";
      };
      submissionsOptions = {
        milter_macro_daemon_name = "ORIGINATING";
        smtpd_client_restrictions = "permit_sasl_authenticated,reject";
        smtpd_sasl_path = "inet:127.0.0.1:12345";
        smtpd_sasl_auth_enable = "yes";
        smtpd_sasl_type = "dovecot";
      };
      extraAliases = ''
        nix: x123
        apt-hunt: x123
      '';
      extraConfig = ''
        smtpd_recipient_restrictions =
          permit_sasl_authenticated
          reject_non_fqdn_recipient
          reject_unknown_recipient_domain
          reject_unauth_destination
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
