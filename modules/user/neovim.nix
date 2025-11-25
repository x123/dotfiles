{pkgs, ...}: {
  imports = [];

  home = {
    packages = with pkgs; [
      elixir-ls
      gopls
      marksman
      nixd
      terraform-ls
      vscode-langservers-extracted
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
      vimPlugins.nvim-treesitter-parsers.c
      vimPlugins.nvim-treesitter-parsers.elixir
      vimPlugins.nvim-treesitter-parsers.go
      vimPlugins.nvim-treesitter-parsers.json
      vimPlugins.nvim-treesitter-parsers.lua
      vimPlugins.nvim-treesitter-parsers.markdown
      vimPlugins.nvim-treesitter-parsers.nix
      vimPlugins.nvim-treesitter-parsers.terraform
      vimPlugins.nvim-treesitter-parsers.vimdoc
      vimPlugins.nvim-treesitter-parsers.zig

      vimPlugins.telescope-nvim
      vimPlugins.tmux-nvim
    ];
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      syntax off
      filetype plugin indent on
      set cursorline
      set showmatch
      let g:airline_theme='base16_nord'
      set number relativenumber
      set expandtab
      set tabstop=2
      set shiftwidth=2
      set background=dark
      set nohlsearch

      nnoremap <C-up> <cmd>lua require("tmux").move_top()<cr>
      nnoremap <C-down> <cmd>lua require("tmux").move_bottom()<cr>
      nnoremap <C-left> <cmd>lua require("tmux").move_left()<cr>
      nnoremap <C-right> <cmd>lua require("tmux").move_right()<cr>

      nnoremap <leader>ff <cmd>Telescope find_files<cr>
      nnoremap <leader>fg <cmd>Telescope live_grep<cr>
      nnoremap <leader>fb <cmd>Telescope buffers<cr>
      nnoremap <leader>fh <cmd>Telescope help_tags<cr>
    '';
    extraLuaConfig = ''
      vim.opt.termguicolors = true
      require('lualine').setup{
        options = {
          theme = 'nord'
        }
      }

      require("telescope").setup()

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

      require("nvim-treesitter.configs").setup {
        indent = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
        },
        highlight = {
          enable = true,
        },
      }

      local lspconfig = require("lspconfig")
      lspconfig.cssls.setup {}
      lspconfig.elixirls.setup {
      	cmd = { "${pkgs.elixir-ls}/bin/elixir-ls" };
      }
      lspconfig.eslint.setup {}
      lspconfig.gopls.setup {}
      lspconfig.html.setup {}
      lspconfig.jsonls.setup {}
      lspconfig.lua_ls.setup {}
      lspconfig.marksman.setup {}
      lspconfig.nixd.setup {}
      lspconfig.terraformls.setup {}

      vim.cmd[[colorscheme nord]]
    '';
  };

}
