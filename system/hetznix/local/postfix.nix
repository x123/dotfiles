{config, ...}: {
  services.postfix = {
    enable = true;
    sslCert = config.security.acme.certs."boxchop.city".directory + "/full.pem";
    sslKey = config.security.acme.certs."boxchop.city".directory + "/key.pem";
  };
}
