{pkgs, ...}: {
  imports = [];

  services.gpg-agent = {
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

  programs.ssh = {
    extraConfig = (if pkgs.stdenv.isDarwin then ''''
    else ''
      Match host * exec "gpg-connect-agent UPDATESTARTUPTTY /bye"
    ''
    );
  };

}
