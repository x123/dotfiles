# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nix-settings # do not remove
    ../../modules/system-nixos
  ];

  custom.system-nixos = {
    enable = true;

    common = {
      console-theme.enable = false;
    };

    dev.elixir.enable = false;
    games.enable = true;

    hardware = {
      bluetooth.enable = true;
      nvidia.enable = true;
      sound.enable = true;
    };

    services = {
      invidious = {
        enable = true;
        domain = "invidious.xnix.lan";
      };

      jellyfin.enable = true;
      nix-ssh-serve.enable = false;
    };

    x11.enable = true;
  };

  users.groups.ssl = {};

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

    secrets = {
      "ssl/invidious.xnix.lan/cert" = {
        mode = "0644";
        owner = config.users.users.root.name;
        group = config.users.groups.ssl.name;
      };
      "ssl/invidious.xnix.lan/key" = {
        mode = "0640";
        owner = config.users.users.root.name;
        group = config.users.groups.ssl.name;
      };

      "muttrc" = {
        mode = "0400";
        owner = config.users.users.x.name;
        #group = "wheel";
      };

      "tg/nixiumbot" = {
        mode = "0440";
        owner = config.users.users.root.name;
        group = "wheel";
      };
    };
  };

  # allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowAliases = false;
  };

  # networking
  networking = {
    hostName = "xnix";
    domain = "empire.boxchop.city";
  };

  networking.networkmanager.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22];
    extraInputRules = ''
      ip saddr { 192.168.1.0/24, 192.168.9.0/24 } tcp dport {22, 80, 443, 9090} accept
    '';
  };
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
      git
      vim
      wget
      ;
  };

  time.timeZone = "Europe/Copenhagen";

  users.users.x = {
    isNormalUser = true;
    description = "x";
    extraGroups = ["networkmanager" "wheel" "jellyfin"];
    shell = pkgs.zsh;
    useDefaultShell = true;
    initialHashedPassword = "$2b$05$xfNWBnjifpR7HFG1rPKbde/rUZdwaTRMLDVJIxAMv6fbkjc5NFm8W";
  };

  system.stateVersion = "23.05"; # Did you read the comment?
}
