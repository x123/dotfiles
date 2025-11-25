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
      settings.main = {
        # Basic Configuration
        home_mailbox = "Maildir/";
        inet_interfaces = "all";
        inet_protocols = "all";
        milter_default_action = "accept";
        milter_protocol = "2";
        mydestination = "hetznix.nixlink.net social.nixlink.net nixlink.net localhost";
        mydomain = "nixlink.net";
        myhostname = "hetznix.nixlink.net";
        myorigin = "nixlink.net";
        non_smtpd_milters = "unix:/run/opendkim/opendkim.sock";
        propagate_unmatched_extension = "";
        recipient_delimiter = "+";
        relay_domains = null; # Was empty string, now null for new format
        relayhost = null; # Was empty string, now null for new format
        smtpd_milters = "unix:/run/opendkim/opendkim.sock";
        smtpd_sasl_path = "inet:127.0.0.1:12345";
        smtpd_sasl_type = "dovecot";
        smtpd_tls_chain_files = [
          (config.security.acme.certs."nixlink.net".directory + "/key.pem")
          (config.security.acme.certs."nixlink.net".directory + "/fullchain.pem")
        ];
        smtp_tls_chain_files = [
          (config.security.acme.certs."nixlink.net".directory + "/key.pem")
          (config.security.acme.certs."nixlink.net".directory + "/fullchain.pem")
        ];

        # SMTP Recipient Restrictions
        smtpd_recipient_restrictions = [
          "permit_sasl_authenticated"
          "reject_non_fqdn_recipient"
          "reject_unknown_recipient_domain"
          "reject_unauth_destination"
          "reject_rbl_client zen.spamhaus.org=127.0.0.[2..11]"
          "reject_rhsbl_sender dbl.spamhaus.org=127.0.1.[2..99]"
          "reject_rhsbl_helo dbl.spamhaus.org=127.0.1.[2..99]"
          "reject_rhsbl_reverse_client dbl.spamhaus.org=127.0.1.[2..99]"
          "warn_if_reject reject_rbl_client zen.spamhaus.org=127.255.255.[1..255]"
        ];

        # Reject the request if the sender is the null address and there are multiple recipients
        smtpd_data_restrictions = "reject_multi_recipient_bounce";

        # Sender Restrictions
        smtpd_sender_restrictions = [
          "reject_non_fqdn_sender"
          "reject_unknown_sender_domain"
          "reject_unauthenticated_sender_login_mismatch"
        ];
      };
    };

    opendkim = {
      enable = true;
      domains = "csl:nixlink.net,social.nixlink.net,hetznix.nixlink.net";
      selector = "default";
      configFile = pkgs.writeText "opendkim.conf" ''
        UMask 0007
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
              # SMTP/SMTPS
              tcp dport 25 counter accept comment "Allow SMTP/25"
              tcp dport 465 counter accept comment "Allow SMTPS/465"
              tcp dport 587 counter accept comment "Allow SMTPS/587"
            }
          '';
        };
      };
    };
  };
}
