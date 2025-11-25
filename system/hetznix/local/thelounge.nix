{pkgs, ...}: {
  services = {
    thelounge = {
      enable = true;
      port = 9000;
      public = false;
      extraConfig = {
        reverseProxy = true;
        host = "127.0.0.1";
      };
    };

    caddy = {
      enable = true;
      virtualHosts = {
        "tl.nixlink.net" = {
          useACMEHost = "nixlink.net";
          extraConfig = ''
            reverse_proxy 127.0.0.1:9000
          '';
        };
      };
    };
  };
}
