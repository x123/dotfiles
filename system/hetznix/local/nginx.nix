{_, ...}: {
  # this is needed to disable automatic ACME cert grab from invidious our own
  # definition in security.acme.certs (in acme.nix)
  # services.nginx.virtualHosts = {
  #   "blockblaster.nixlink.net" = {
  #     enableACME = false;
  #     useACMEHost = "nixlink.net";
  #     forceSSL = true;
  #     root = "/var/www/blockblaster.nixlink.net";
  #     locations."/blockblaster" = {
  #     };
  #   };
  # };
}
