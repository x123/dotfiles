{
  config,
  pkgs,
  ...
}: {
  imports = [];

  sops = {
    secrets = {
      "binary-cache/nixium/private" = {};
      "binary-cache/nixium/private".mode = "0400";
      "binary-cache/nixium/public" = {};
      "binary-cache/nixium/public".mode = "0444";
    };
  };

  services.nix-serve = {
    enable = true;
    secretKeyFile = config.sops.secrets."binary-cache/nixium/private".path;
  };

  services.nginx = {
    enable = true;

    recommendedProxySettings = true;

    virtualHosts = {
      # ... existing hosts config etc. ...
      "nixium.boxchop.city" = {
        addSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "root@boxchop.city";
  };
}
