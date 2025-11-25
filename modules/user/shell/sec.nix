{pkgs, ...}: {
  imports = [];
  home = {
    packages = builtins.attrValues {
      inherit
        (pkgs)
        ffuf
        netcat-gnu
        urlencode
        ;
      inherit
        (pkgs.unstable-small)
        ip2asn
        ;
      inherit
        (pkgs.python312Packages)
        defang
        ;
    };
  };
}
