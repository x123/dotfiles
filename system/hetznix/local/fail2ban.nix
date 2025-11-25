{...}: {
  services.fail2ban = {
    enable = true;
    jails = {
      dovecot = {
        settings = {
          filter = "dovecot[mode=aggressive]";
          maxretry = 3;
        };
      };
    };
  };
}
