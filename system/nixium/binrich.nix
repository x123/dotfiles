{ config, pkgs, ... }: {
  imports = [ ];

  sops.secrets."postgres/nixium/binrich/DBNAME" = { };
  sops.secrets."postgres/nixium/binrich/DBUSER" = { };
  sops.secrets."postgres/nixium/binrich/DBPASS" = { };
  sops.secrets."postgres/nixium/binrich/DBHOST" = { };
}
