{pkgs, ...}: {
  imports = [];

  programs.vim = {
    enable = true;
    defaultEditor = true;
    settings = {
      number = true;
      relativenumber = true;
      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      background = "dark";
    };
    extraConfig = ''
      syntax on
      filetype plugin indent on
      set cursorline
      set showmatch
    '';
  };

}