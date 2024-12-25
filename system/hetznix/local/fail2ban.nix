{...}: {
  environment.etc = {
    "fail2ban/filter.d/dovecot2-custom.conf".text = ''
      [Definition]
      failregex = ^.*authentication failure; logname=<F-ALT_USER1>\S*</F-ALT_USER1> uid=\S* euid=\S* tty=dovecot ruser=<F-USER>\S*</F-USER> rhost=<HOST>(?:\s+user=<F-ALT_USER>\S*</F-ALT_USER>)?\s*$
      journalmatch = _SYSTEMD_UNIT=dovecot2.service
    '';
  };

  services.fail2ban = {
    enable = true;
    banaction = ''nftables-allports[blocktype=drop]'';
    banaction-allports = ''nftables-allports[blocktype=drop]'';
    ignoreIP = [
      "127.0.0.1/8"
      "nixlink.net"
      "empire.nixlink.net"
    ];
    bantime = "10m";
    bantime-increment = {
      enable = true;
      formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
      maxtime = "7d";
      overalljails = true;
    };
    jails = {
      dovecot = {
        settings = {
          filter = "dovecot2-custom[mode=normal]";
          maxretry = 3;
          backend = "systemd";
        };
      };
    };
  };
}
