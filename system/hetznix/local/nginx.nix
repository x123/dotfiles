{_, ...}: {
  # this is needed to disable automatic ACME cert grab from invidious our own
  # definition in security.acme.certs (in acme.nix)
  # services.nginx.virtualHosts = {
  #   "blockblaster.boxchop.city" = {
  #     enableACME = false;
  #     useACMEHost = "boxchop.city";
  #     forceSSL = true;
  #     root = "/var/www/blockblaster.boxchop.city";
  #     locations."/blockblaster" = {
  #     };
  #   };
  # };
}
