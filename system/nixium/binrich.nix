{ config, pkgs, ... }: {
  imports = [ ];

  sops.secrets."postgres/nixium/binrichfile" = { };
}
