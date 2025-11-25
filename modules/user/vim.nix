{pkgs, ...}: {
  imports = [];

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      nerdtree
      nerdtree-git-plugin
      vim-airline
      vim-airline-themes
      vim-elixir
      vim-fugitive
      vim-lastplace
      vim-lsp
      vim-lsp-settings
      vim-nix
      vim-tmux-navigator
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
      nnoremap <leader>n :NERDTreeFocus<CR>
      nnoremap <C-n> :NERDTree<CR>
      nnoremap <C-t> :NERDTreeToggle<CR>
      nnoremap <C-f> :NERDTreeFind<CR>
      let g:tmux_navigator_no_mappings = 1
      nnoremap <C-up> :TmuxNavigateUp<CR>
      nnoremap <C-down> :TmuxNavigateDown<CR>
      nnoremap <C-left> :TmuxNavigateLeft<CR>
      nnoremap <C-right> :TmuxNavigateRight<CR>
      nnoremap <C-tab> :TmuxNavigatePrevious<CR>
    '';
  };

}
