{
  config,
  inputs,
  lib,
  ...
}: let
  stevenBlackHostsFile = "${inputs.stevenblack}/hosts";

  hostsFileContent = builtins.readFile stevenBlackHostsFile;

  allLines = lib.strings.splitString "\n" hostsFileContent;

  # 4. Filter for valid '0.0.0.0' block entries
  hostLines =
    lib.filter (
      line: let
        fields = lib.filter (f: f != "") (lib.strings.splitString " " line);
      in
        # Ensure it's a valid block line:
        # 1. Has at least 2 fields
        (lib.length fields >= 2)
        &&
        # 2. Starts with "0.0.0.0"
        (lib.elemAt fields 0 == "0.0.0.0")
        &&
        # 3. Domain is not "0.0.0.0"
        (lib.elemAt fields 1 != "0.0.0.0")
    )
    allLines;

  # 5. Transform each line into the 'local-zone' format
  blocklistEntries =
    lib.map (
      line: let
        fields = lib.filter (f: f != "") (lib.strings.splitString " " line);
        domain = lib.elemAt fields 1;
      in
        # Format: '"domain.com" always_nxdomain'
        # The NixOS module will add the 'local-zone:' prefix.
        ''"${domain}" always_nxdomain''
    )
    hostLines;
in {
  users.users.unbound.extraGroups = ["acme"];

  services = {
    unbound = {
      enable = true;
      enableRootTrustAnchor = true;
      checkconf = false; # wont work if settings.remote-control or settings.include are used
      resolveLocalQueries = false; # so 127.0.0.1 doesn't get added to /etc/resolv.conf
      settings = {
        server = {
          interface = [
            # "0.0.0.0@53"
            # "::0@53"
            "0.0.0.0@853"
            "::0@853"
          ];
          access-control = ["0.0.0.0/0 allow" "::0/0 allow"];
          harden-glue = true;
          harden-dnssec-stripped = true;
          use-caps-for-id = false;
          prefetch = true;
          edns-buffer-size = 1232;
          hide-identity = true;
          hide-version = true;
          tls-service-pem = config.security.acme.certs."nixlink.net".directory + "/cert.pem";
          tls-service-key = config.security.acme.certs."nixlink.net".directory + "/key.pem";
          local-zone = blocklistEntries; # add blocklist entries from StevenBlack list
        };
      };
    };
  };

  networking = {
    nftables = {
      enable = true; # enable nftables
      tables = {
        filter = {
          family = "inet";
          content = ''
            chain input-new {
              # unbound
              # udp dport 53 counter accept comment "Allow UDP/53 unbound"
              # tcp dport 53 counter accept comment "Allow TCP/53 unbound"
              tcp dport 853 counter accept comment "Allow TCP/853 unbound DNS-over-TLS"
            }
          '';
        };
      };
    };
  };
}
