{config, ...}: {
  sops.secrets = {
    "wireguard/config" = {
      mode = "0400";
    };
  };

  networking.wg-quick.interfaces.wg0.configFile = config.sops.secrets."wireguard/config".path;
}
