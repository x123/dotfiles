{...}: {
  services = {
    ntfy-sh = {
      enable = true;
      settings = {
        listen-http = "127.0.0.1:2586";
        base-url = "https://ntfy.boxchop.city:8883";
        auth-default-access = "deny-all";
        behind-proxy = true;
      };
    };

    caddy = {
      enable = true;
      virtualHosts = {
        "ntfy.boxchop.city" = {
          useACMEHost = "boxchop.city";
          extraConfig = ''
            reverse_proxy 127.0.0.1:2586

            @httpget {
              protocol http
              method GET
              path_regexp ^/([-_a-z0-9]{0,64}$|docs/|static/)
            }
            redir @httpget https://{host}{uri}
          '';
        };
      };
    };
  };
}
