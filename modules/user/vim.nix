{pkgs, ...}: {
  imports = [];

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-airline-themes
      vim-lastplace
      vim-nix
    ];
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
      let g:airline_theme='base16_nord'
    '';
  };

}
