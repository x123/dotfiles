{
  lib,
  pkgs,
  ...
}: let
  logout-macro = pkgs.writeShellScript "logout-macro" ''
    set -euo pipefail
    sudo ${pkgs.nftables}/bin/nft insert rule inet filter input tcp flags { psh, ack } tcp sport 6112 counter reject with tcp reset
    HANDLE=$(sudo ${pkgs.nftables}/bin/nft -a list ruleset | ${pkgs.gnugrep}/bin/egrep "tcp sport 6112 counter.*tcp reset # handle ([0-9]+)" | ${pkgs.gawk}/bin/awk -F "# handle " '{print $2}')
    echo $HANDLE
    sleep 1
    sudo ${pkgs.nftables}/bin/nft delete rule inet filter input handle $HANDLE
  '';
in {
  home.file = {
    xbindkeysrc = {
      enable = true;
      target = ".xbindkeysrc";
      text = ''
        "${logout-macro}"
          m:0x0 + c:49
      '';
    };
    # logout-macro = {
    #   enable = true;
    #   executable = true;
    #   target = "bin/logout-macro";
    #   source = pkgs.writeShellScript "logout-macro" ''
    #     set -euo pipefail
    #     sudo ${pkgs.nftables}/bin/nft insert rule inet filter input tcp flags { psh, ack } tcp sport 6112 counter reject with tcp reset
    #     HANDLE=$(sudo ${pkgs.nftables}/bin/nft -a list ruleset | ${pkgs.gnugrep}/bin/egrep "tcp sport 6112 counter.*tcp reset # handle ([0-9]+)" | ${pkgs.gawk}/bin/awk -F "# handle " '{print $2}')
    #     echo $HANDLE
    #     sleep 1
    #     sudo ${pkgs.nftables}/bin/nft delete rule inet filter input handle $HANDLE
    #   '';
    # };
  };
}
