{...}: {
  services = {
    ntfy-sh = {
      enable = true;
      settings = {
        listen-http = "127.0.0.1:2586";
        base-url = "https://ntfy.nixlink.net";
        upstream-base-url = "https://ntfy.sh";
        auth-default-access = "deny-all";
        behind-proxy = true;
      };
    };

    caddy = {
      enable = true;
      virtualHosts = {
        "ntfy.nixlink.net" = {
          useACMEHost = "nixlink.net";
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
