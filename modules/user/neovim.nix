{ pkgs, ... }: {
  imports = [ ];

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
      set scrolloff=10

      nnoremap <C-up> <cmd>lua require("tmux").move_top()<cr>
      nnoremap <C-down> <cmd>lua require("tmux").move_bottom()<cr>
      nnoremap <C-left> <cmd>lua require("tmux").move_left()<cr>
      nnoremap <C-right> <cmd>lua require("tmux").move_right()<cr>

      nnoremap <space>w\ <cmd>vsplit<cr>
      nnoremap <space>ws <cmd>split<cr>
      nnoremap <space>qq <cmd>quit<cr>
      nnoremap <space>zz <cmd>wq<cr>
      nnoremap <space>wx <C-W>x

    '';
    extraLuaConfig = ''
      vim.opt.termguicolors = true
      require('lualine').setup{
        options = {
          theme = 'nord'
        }
      }

      -- Telescope
      require("telescope").setup()

      vim.keymap.set("n", "<space>ff", "<cmd>Telescope find_files<cr>")
      vim.keymap.set("n", "<space>fg", "<cmd>Telescope live_grep<cr>")
      vim.keymap.set("n", "<space>fb", "<cmd>Telescope buffers<cr>")
      vim.keymap.set("n", "<space>fh", "<cmd>Telescope help_tags<cr>")

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

      require("nvim-lastplace").setup {
        lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
        lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
        lastplace_open_folds = true
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

      vim.opt.mouse = ""

      -- move visual selection up and down
      vim.keymap.set("v", "<S-Up>", ":m '<-2<CR>gv=gv")
      vim.keymap.set("v", "<S-Down>", ":m '>+1<CR>gv=gv")

      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<space>Wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<space>Wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<space>Wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<space>F', function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end,
      })

      vim.g.nord_contrast = true
      vim.g.nord_borders = false
      vim.g.nord_disable_background = false
      vim.g.nord_italic = false
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_bold = true
      vim.cmd[[colorscheme nord]]
    '';
  };

}
