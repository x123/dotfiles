{config, ...}: {
  sops.secrets = {
    "xmrig-proxy-conf" = {
      # mode = "0444";
    };
  };

  custom.system-nixos = {
    enable = true;

    services = {
      xmrig-proxy = {
        enable = true;
        configFile = config.sops.secrets."xmrig-proxy-conf".path;
        openFirewallNftables = true;
        trustedIpv4Networks = ["0.0.0.0/0"];
        trustedIpv6Networks = ["::/0"];
      };
    };
  };
}
