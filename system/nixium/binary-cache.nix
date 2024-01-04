{config, pkgs, ...}: {
  imports = [];

  sops.secrets."binary-cache/nixium/private" = {};
  sops.secrets."binary-cache/nixium/private".mode = "0400";
  sops.secrets."binary-cache/nixium/public" = {};
  sops.secrets."binary-cache/nixium/public".mode = "0444";

  services.nix-serve = {
    enable = true;
    secretKeyFile = config.sops.secrets."binary-cache/nixium/private".path;
  };
}
