{...}: {
  services.caddy = {
    enable = true;
    virtualHosts = {
      "ip.nixlink.net" = {
        useACMEHost = "nixlink.net";
        extraConfig = ''
          templates
          header Content-Type text/plain
          respond "{{.RemoteIP}}"
          encode zstd gzip
        '';
      };
      "ip6.nixlink.net" = {
        listenAddresses = ["2a01:4f8:1c1b:51d1::6"];
        useACMEHost = "nixlink.net";
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
