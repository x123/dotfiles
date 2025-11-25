{
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ../../modules/system/nix-settings.nix # do not remove
    ../../modules/system/zsh.nix
    ./local/acme.nix
    ./local/invidious.nix
    ./local/mastodon.nix
    ./local/nginx.nix
    ./local/postgres.nix
    # ./local/maddy.nix
  ];

  boot = {
    binfmt.emulatedSystems = ["x86_64-linux"];
    initrd.availableKernelModules = ["xhci_pci" "virtio_scsi" "sr_mod"];
    initrd.kernelModules = [];
    kernelModules = [];
    extraModulePackages = [];
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;

    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/root/.config/sops/age/keys.txt";
      generateKey = true;
    };
  };

  networking = {
    hostName = "hetznix";
    domain = "boxchop.city";
    enableIPv6 = true;
    interfaces.enp1s0.ipv6.addresses = [
      {
        address = "2a01:4f8:1c1b:51d1::";
        prefixLength = 64;
      }
    ];
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp1s0";
    };
  };

  networking.firewall = {
    enable = false;
    allowedTCPPorts = [22 80 443];
    # extraInputRules = ''
    #   ip saddr { 192.168.1.0/24, 192.168.9.0/24 } tcp dport {22, 9090} accept
    # '';
  };

  networking.nftables = {
    enable = true;
    tables = {
      filter = {
        family = "inet";
        content = ''
          counter cnt_input_drop {
              comment "count all packets that hit the final drop in the input chain"
          }

          set ks1 {
            type ipv4_addr
            flags timeout
            timeout 10s
            gc-interval 4s
          }
          set ks2 {
            type ipv4_addr
            flags timeout
            timeout 10s
            gc-interval 4s
          }
          set ks3 {
            type ipv4_addr
            flags timeout
            timeout 10s
            gc-interval 4s
          }
          set ks4 {
            type ipv4_addr
            flags timeout
            timeout 2m
            gc-interval 4s
          }

          chain k1 {
            set add ip saddr @ks1
          }
          chain uk1 {
            set update ip saddr timeout 0s @ks1
          }
          chain k2 {
            set update ip saddr timeout 0s @ks1
            set add ip saddr @ks2
          }
          chain uk2 {
            set update ip saddr timeout 0s @ks2
          }
          chain k3 {
            set update ip saddr timeout 0s @ks2
            set add ip saddr @ks3
          }
          chain uk3 {
            set update ip saddr timeout 0s @ks3
          }
          chain k4 {
            set update ip saddr timeout 0s @ks3
            set add ip saddr @ks4 log prefix "nft-pn accepted: "
          }

          chain refk {
            set update ip saddr timeout 2m @ks4
          }

          # 8209, 15388, 48665, 49676
          chain pk {
            ct state new ip saddr @ks4 goto refk
            tcp dport 49676 ct state new ip saddr @ks3 goto k4
            tcp dport 48665 ct state new ip saddr @ks3 return
            ip saddr @ks3 ct state new goto uk3
            tcp dport 48665 ct state new ip saddr @ks2 goto k3
            tcp dport 15388 ct state new ip saddr @ks2 return
            ip saddr @ks2 ct state new goto uk2
            tcp dport 15388 ct state new ip saddr @ks1 goto k2
            tcp dport 8209 ct state new ip saddr @ks1 return
            ip saddr @ks1 ct state new goto uk1
            tcp dport 8209 ct state new goto k1
          }

          # ipv6/icmpv6 chain
          chain ipv6 {
              ip6 nexthdr icmpv6 icmpv6 type {
                  destination-unreachable, # type 1
                  packet-too-big, # type 2
                  time-exceeded, # type 3
                  parameter-problem, # type 4
                  echo-request, # type 128
                  echo-reply, # type 129
                  nd-neighbor-solicit,
              } counter accept \
              comment "Accept basic IPv6 functionality"

              ip6 nexthdr icmpv6 icmpv6 type {
                  nd-router-solicit, # type 133
                  nd-router-advert, # type 134
                  nd-neighbor-solicit, # type 135
                  nd-neighbor-advert, # type 136
              } ip6 hoplimit 255 accept \
              comment "Allow IPv6 SLAAC"

              ip6 nexthdr icmpv6 icmpv6 type {
                  mld-listener-query, # type 130
                  mld-listener-report, # type 131
                  mld-listener-reduction, # type 132
                  mld2-listener-report, # type 143
              } ip6 saddr fe80::/10 counter accept \
              comment "Allow IPv6 multicast listener discovery on link-local"

              ip6 saddr fe80::/10 udp sport 547 udp dport 546 accept \
              comment "Accept DHCPv6 replies from IPv6 link-local addresses"

              return
          }

          chain input {
              type filter hook input priority 0; policy drop; # default drop

              # loopback interface
              iifname "lo" accept comment "Always accept loopback"

              # established/related connections
              ct state established,related counter accept comment "Accept established/related connections"

              # invalid connections
              ct state invalid limit rate 1/second burst 5 packets log prefix "nft-input-drop bad-state-in: "
              ct state invalid counter drop comment "Drop invalid connections"

              # icmp ping/traceroute
              icmp type echo-request counter accept comment "Accept ICMP ping requests"
              udp dport 33434-33523 counter reject comment "Properly reject traceroute UDP requests"

              # jump to ipv6 chain and return
              jump ipv6

              # pk
              jump pk

              # ntp
              udp dport 123 counter accept comment "Allow NTP"

              tcp dport 22 ip saddr @ks4 log prefix "nft-input-pn-traffic-accept: "
              tcp dport 22 ip saddr @ks4 counter accept

              # HTTP/HTTPS
              tcp dport { 80, 443 } log prefix "nft-input-accept: "
              tcp dport { 80, 443 } counter accept

              # ssh whitelisted
              # ip saddr @ssh_whitelisted tcp dport 22 ct state new counter accept comment "Allow whitelisted SSH"

              limit rate 60/minute burst 20 packets log prefix "nft-input-drop: " level info
              counter name cnt_input_drop drop
          }

          # output chain
          chain output {
              type filter hook output priority 0; policy accept;

              # loopback interface
              oifname "lo" accept comment "Always accept loopback"

              # established/related connections
              ct state related,established counter accept comment "Accept established/related connections"

              # invalid connections
              ct state invalid limit rate 1/second burst 5 packets log prefix "nft-output-drop bad-state-out: "
              ct state invalid counter drop comment "Drop invalid connections"

              # icmp
              icmp type {echo-request,echo-reply} counter accept comment "Accept ICMP ping requests"

              # icmpv6
              icmpv6 type {echo-request,echo-reply} counter accept comment "Accept ICMPv6 requests"

              # DNS
              tcp dport 53 counter accept comment "Allow DNS on TCP/53"
              udp dport 53 counter accept comment "Allow DNS on UDP/53"

              # NTP
              udp dport 123 counter accept comment "Allow NTP/123"

              # SMTP/SMTPS
              tcp dport 25 ct state new counter accept comment "Allow SMTP/25"
              tcp dport 465 ct state new counter accept comment "Allow SMTPS/465"
          }
        '';
      };
    };
  };

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      vim
      wget
      ;
  };

  users = {
    motdFile = ./files/hetznix.motd;

    users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAV4W4TVF5yqOwKFax+b2XtRYbdKy1wy4zFXfFZfv5be xnix"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID6elYl8CWSR32Zx33D+XgQWM/721sDmnyFJec7vDeMb fom-mba"
    ];

    users.x123 = {
      createHome = true;
      isNormalUser = true;
      description = "x123";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;
      useDefaultShell = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAV4W4TVF5yqOwKFax+b2XtRYbdKy1wy4zFXfFZfv5be xnix"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID6elYl8CWSR32Zx33D+XgQWM/721sDmnyFJec7vDeMb fom-mba"
      ];
    };
  };

  system.stateVersion = "24.05";
}
