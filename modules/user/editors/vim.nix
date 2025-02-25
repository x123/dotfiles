{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options.custom.editors.vim.enable = lib.mkEnableOption "classic vim";

  config = lib.mkIf config.custom.editors.vim.enable {
    home = {
      packages = builtins.attrValues {
        inherit
          (pkgs)
          elixir-ls
          gopls
          marksman
          nixd
          terraform-ls
          vscode-langservers-extracted
          ;
      };
    };

    programs.vim = {
      enable = true;
      plugins = builtins.attrValues {
        inherit
          (pkgs.vimPlugins)
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
          ;
      };
      defaultEditor = false;
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
        nnoremap <C-tab> :TmuxNavigatePrevious<CR>

        nnoremap <C-k> :TmuxNavigateUp<CR>
        nnoremap <C-j> :TmuxNavigateDown<CR>
        nnoremap <C-h> :TmuxNavigateLeft<CR>
        nnoremap <C-l> :TmuxNavigateRight<CR>

        nnoremap <C-up> :TmuxNavigateUp<CR>
        nnoremap <C-down> :TmuxNavigateDown<CR>
        nnoremap <C-left> :TmuxNavigateLeft<CR>
        nnoremap <C-right> :TmuxNavigateRight<CR>
        nnoremap <C-tab> :TmuxNavigatePrevious<CR>
      '';
    };
  };
}
