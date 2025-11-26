{config, ...}: {
  sops.secrets = {
    "xnix-nix-cache/pub" = {
      mode = "0444";
      # owner = "root";
      # group = "root";
    };
    "xnix-nix-cache/private" = {
      mode = "0400";
      # owner = "root";
      # group = "root";
    };
  };
  nix.settings.secret-key-files = [
    config.sops.secrets."xnix-nix-cache/private".path
  ];
}
