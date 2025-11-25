{ pkgs, inputs, ... }: {
  imports = [ ];

  # currently managing config with sops
  # programs.neomutt = {
  #   enable = true;
  #   #settings = {};
  #   sidebar.enable = true;
  #   sort = "reverse-date-received";
  #   vimKeys = true;
  #   extraConfig = ''
  #   '';
  # };
  home = {
    packages = with pkgs; [
      neomutt
    ];

    shellAliases = {
      neomutt = "neomutt -F /run/secrets/muttrc";
    };
  };

}
