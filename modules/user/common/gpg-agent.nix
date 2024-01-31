{pkgs, ...}: {
  imports = [];

  services.gpg-agent = {
    enable =
      if pkgs.stdenv.isDarwin
      then false
      else true;

    defaultCacheTtl = 31536000;
    defaultCacheTtlSsh = 31536000;
    maxCacheTtl = 31536000;
    maxCacheTtlSsh = 31536000;
    enableSshSupport = true;
    pinentryFlavor = "tty";
    extraConfig =
      ''
        pinentry-program ${pkgs.pinentry-qt}/bin/pinentry
      ''
      + ''
        allow-loopback-pinentry
      '';
  };

  programs.ssh = {
    extraConfig =
      if pkgs.stdenv.isDarwin
      then ''''
      else ''
        Match host * exec "gpg-connect-agent UPDATESTARTUPTTY /bye"
      '';
  };
}
