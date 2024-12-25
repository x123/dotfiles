{...}: {
  services.caddy = {
    enable = true;
    virtualHosts = {
      "ip.boxchop.city" = {
        useACMEHost = "boxchop.city";
        extraConfig = ''
          templates
          header Content-Type text/plain
          respond "{{.RemoteIP}}"
          encode zstd gzip
        '';
      };
      "ip6.boxchop.city" = {
        listenAddresses = ["2a01:4f8:1c1b:51d1::6"];
        useACMEHost = "boxchop.city";
        extraConfig = ''
          templates
          header Content-Type text/plain
          respond "{{.RemoteIP}}"
          encode zstd gzip
        '';
      };
    };
  };
}
