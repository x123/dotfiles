{ config, pkgs, inputs, ... }: {
  imports = [ ];

  sops.secrets."postgres/nixium/binrichfile" = {
    mode = "0400";
    owner = config.users.users.binrich.name;
  };

  # environment.systemPackages = [
  #   inputs.binrich.packages.${pkgs.stdenv.hostPlatform.system}.binrich
  # ];

  users.users.binrich = {
    createHome = true;
    isNormalUser = true;
    description = "binrich";
    shell = pkgs.zsh;
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAV4W4TVF5yqOwKFax+b2XtRYbdKy1wy4zFXfFZfv5be xnix"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID6elYl8CWSR32Zx33D+XgQWM/721sDmnyFJec7vDeMb fom-mba"
    ];
  };

}
