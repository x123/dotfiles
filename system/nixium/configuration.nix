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

  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  sops.age.keyFile = "/root/.config/sops/age/keys.txt";
  sops.age.generateKey = true;

  sops.secrets."ssh/nixium/private" = {};
  sops.secrets."ssh/nixium/public" = {};

  sops.secrets."tg/nixiumbot" = {};

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

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

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
