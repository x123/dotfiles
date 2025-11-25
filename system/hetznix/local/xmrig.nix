{config, ...}: {
  sops.secrets = {
    "xmrig" = {
    };
  };

  custom.system-nixos = {
    services = {
      xmrig = {
        enable = true;
        configFile = config.sops.secrets."xmrig".path;
      };
    };
  };
}
