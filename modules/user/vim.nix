{pkgs, ...}: {
  imports = [];

  home = {
    packages = with pkgs; [
      elixir-ls
      gopls
      marksman
      nerdfonts
      nixd
      terraform-ls
    ];
  };

  programs.neovim = {
    enable = true;
    plugins = with pkgs; [
      vimPlugins.lualine-nvim
      vimPlugins.mason-lspconfig-nvim
      vimPlugins.mason-nvim
      vimPlugins.nord-nvim
      vimPlugins.nvim-lastplace
      vimPlugins.nvim-lspconfig
      vimPlugins.nvim-treesitter
      vimPlugins.nvim-treesitter-parsers.markdown
      vimPlugins.nvim-treesitter-parsers.go
      vimPlugins.nvim-treesitter-parsers.elixir
      vimPlugins.nvim-treesitter-parsers.json
      vimPlugins.nvim-treesitter-parsers.nix
      vimPlugins.nvim-treesitter-parsers.terraform
      vimPlugins.tmux-nvim
    ];
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      syntax on
      filetype plugin indent on
      set cursorline
      set showmatch
      let g:airline_theme='base16_nord'
      set number relativenumber
      set expandtab
      set tabstop=2
      set shiftwidth=2
      set background=dark

      nnoremap <C-up> <cmd>lua require("tmux").move_top()<cr>
      nnoremap <C-down> <cmd>lua require("tmux").move_bottom()<cr>
      nnoremap <C-left> <cmd>lua require("tmux").move_left()<cr>
      nnoremap <C-right> <cmd>lua require("tmux").move_right()<cr>
    '';
    extraLuaConfig = ''
      vim.opt.termguicolors = true
      require('lualine').setup{
        options = {
          theme = 'nord'
        }
      }

      require("tmux").setup{
        options = {
          navigation = {
            enable_default_keybindings = false,
          },
          resize = {
            enable_default_keybindings = false,
          }
        }
      }

      require("mason").setup()
      require("mason-lspconfig").setup()

      local lspconfig = require("lspconfig")
      lspconfig.elixirls.setup {
      	cmd = { "${pkgs.elixir-ls}/bin/elixir-ls" };
      }
      lspconfig.gopls.setup {}
      lspconfig.lua_ls.setup {}
      lspconfig.marksman.setup {}
      lspconfig.nixd.setup {}
      lspconfig.terraformls.setup {}

      vim.cmd[[colorscheme nord]]
    '';
  };

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
      nnoremap <C-up> :TmuxNavigateUp<CR>
      nnoremap <C-down> :TmuxNavigateDown<CR>
      nnoremap <C-left> :TmuxNavigateLeft<CR>
      nnoremap <C-right> :TmuxNavigateRight<CR>
      nnoremap <C-tab> :TmuxNavigatePrevious<CR>
    '';
  };

}
