{pkgs, lib, config, ...}:
  let
    inherit (pkgs) stdenv;
    inherit (lib) mkIf;
  in
  {
  imports = [];

  services.gpg-agent = mkIf stdenv.isLinux {
    enable = true;

    defaultCacheTtl = 86400;
    defaultCacheTtlSsh = 86400;
    maxCacheTtl = 86400;
    maxCacheTtlSsh = 86400;
    enableSshSupport = true;
    pinentryFlavor = "tty";
    extraConfig = ''
      pinentry-program ${pkgs.pinentry-qt}/bin/pinentry
    '' + ''
      allow-loopback-pinentry
    '';
  };
}
