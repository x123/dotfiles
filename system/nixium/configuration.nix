{
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/virtualisation/google-compute-image.nix")
    ../../modules/system/nix-settings.nix # do not remove
    ../../modules/system/zsh.nix
    ../../modules/system/elixir.nix
    ./binary-cache.nix
    ./postgres.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen; # lqx or zen or latest

  sops = {
    defaultSopsFile = ./secrets.yaml;

    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/root/.config/sops/age/keys.txt";
      generateKey = true;
    };

    secrets = {
      "ssh/nixium/private" = {};
      "ssh/nixium/public" = {};

      "tg/nixiumbot" = {};
    };
  };

  networking = {
    hostName = "nixium";
    domain = "boxchop.city";
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

  users.motdFile = ./files/nixium.motd;

  users.users.x = {
    createHome = true;
    isNormalUser = true;
    description = "x";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
    useDefaultShell = true;
  };

  system.stateVersion = "24.05";
}
