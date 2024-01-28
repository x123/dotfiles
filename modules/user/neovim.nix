{pkgs, ...}: {
  imports = [];

  home = {
    packages = builtins.attrValues {
      inherit
        (pkgs)
        elixir-ls
        gopls
        marksman
        nil
        nixd
        terraform-ls
        vscode-langservers-extracted
        ;
    };
  };

  programs.neovim = {
    enable = true;
    plugins = builtins.attrValues {
      inherit
        (pkgs.vimPlugins)
        comment-nvim
        gitsigns-nvim
        lualine-nvim
        nord-nvim
        nvim-lastplace
        nvim-lspconfig
        nvim-treesitter
        telescope-nvim
        tmux-nvim
        undotree
        ;
      inherit
        (pkgs.vimPlugins.nvim-treesitter-parsers)
        c
        elixir
        go
        json
        lua
        markdown
        nix
        terraform
        vimdoc
        zig
        ;
    };
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
    '';
    extraLuaConfig = ''
      vim.opt.termguicolors = true

      -- common settings
      vim.opt.mouse = ""
      vim.opt.cursorline = true
      vim.opt.showmatch = true
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.expandtab = true
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.background = "dark"
      vim.opt.hlsearch = false
      vim.opt.scrolloff = 10

      -- personal keybinds
      vim.keymap.set("n", "<space>w\\", "<cmd>vsplit<cr>")
      vim.keymap.set("n", "<space>ws", "<cmd>split<cr>")
      vim.keymap.set("n", "<space>qq", "<cmd>quit<cr>")
      vim.keymap.set("n", "<space>QQ", "<cmd>quit!<cr>")
      vim.keymap.set("n", "<space>zz", "<cmd>wq<cr>")
      vim.keymap.set("n", "<space>wx", "<C-W>x")

      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
      vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

      -- move visual selection up and down
      vim.keymap.set("v", "<S-Up>", ":m '<-2<CR>gv=gv")
      vim.keymap.set("v", "<S-Down>", ":m '>+1<CR>gv=gv")

      vim.keymap.set('n', "<space>U", vim.cmd.UndotreeToggle)

      -- nord
      require("lualine").setup({
        options = {
          theme = "nord"
        }
      })

      vim.g.airline_theme = "base16_nord"

      vim.g.nord_contrast = true
      vim.g.nord_borders = false
      vim.g.nord_disable_background = false
      vim.g.nord_italic = false
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_bold = true
      vim.cmd[[colorscheme nord]]

      require("Comment").setup()

      require("gitsigns").setup({
        signcolumn = true,
        numhl = true,
      })

      -- Telescope
      require("telescope").setup()

      vim.keymap.set("n", "<space>ff", "<cmd>Telescope find_files<cr>")
      vim.keymap.set("n", "<space>fg", "<cmd>Telescope live_grep<cr>")
      vim.keymap.set("n", "<space>fb", "<cmd>Telescope buffers<cr>")
      vim.keymap.set("n", "<space>fh", "<cmd>Telescope help_tags<cr>")

      -- tmux navigation
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

      vim.keymap.set("n", "<C-up>", "<cmd>lua require('tmux').move_top()<cr>")
      vim.keymap.set("n", "<C-down>", "<cmd>lua require('tmux').move_bottom()<cr>")
      vim.keymap.set("n", "<C-left>", "<cmd>lua require('tmux').move_left()<cr>")
      vim.keymap.set("n", "<C-right>", "<cmd>lua require('tmux').move_right()<cr>")

      require("nvim-treesitter.configs").setup({
        indent = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
        },
        highlight = {
          enable = true,
        },
      })

      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
        lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
        lastplace_open_folds = true
      })

      local lspconfig = require("lspconfig")
      lspconfig.cssls.setup({})
      lspconfig.elixirls.setup({
        cmd = { "${pkgs.elixir-ls}/bin/elixir-ls" };
      })
      lspconfig.eslint.setup({})
      lspconfig.gopls.setup({})
      lspconfig.html.setup({})
      lspconfig.jsonls.setup({})
      lspconfig.lua_ls.setup({})
      lspconfig.marksman.setup({})
      lspconfig.nixd.setup({
        autostart = true,
        cmd = { "${pkgs.nixd}/bin/nixd" },
        settings = {
          ['nixd'] = {
            formatting = {
              command = { "${pkgs.alejandra}/bin/alejandra" },
            },
          },
        },
      })
      lspconfig.nil_ls.setup({
        autostart = true,
        cmd = { "${pkgs.nil}/bin/nil" },
        settings = {
          ['nil'] = {
            formatting = {
              command = { "${pkgs.alejandra}/bin/alejandra" },
            },
          },
        },
      })
      lspconfig.terraformls.setup({})

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
         local client = vim.lsp.get_client_by_id(ev.data.client_id)
          client.server_capabilities.semanticTokensProvider = nil
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<space>Wa", vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set("n", "<space>Wr", vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set("n", "<space>Wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({"n", "v"}, "<space>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<space>F", function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end,
      })

    '';
  };
}
