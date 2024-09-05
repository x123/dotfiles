{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  options.custom.editors.neovim.enable = lib.mkEnableOption "neovim";

  config = lib.mkIf config.custom.editors.neovim.enable {
    home = {
      packages =
        builtins.attrValues
        {
          inherit
            (pkgs)
            cargo
            elixir-ls
            gopls
            marksman
            nil
            nixd
            terraform-ls
            vscode-langservers-extracted
            # rust
            
            rust-analyzer
            rustc
            rustfmt
            ;
        };
    };

    programs.neovim = {
      enable = true;
      plugins = builtins.attrValues {
        inherit
          (pkgs.vimPlugins)
          cmp-nvim-lsp
          cmp-nvim-lua
          cmp-path
          cmp-vsnip
          comment-nvim
          gitsigns-nvim
          lspkind-nvim
          lualine-nvim
          nord-nvim
          nvim-cmp
          nvim-lastplace
          nvim-lspconfig
          nvim-surround
          nvim-treesitter
          nvim-web-devicons
          oil-nvim
          telescope-nvim
          tmux-nvim
          undotree
          vim-vsnip
          vim-vsnip-integ
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
        vim.keymap.set("v", "<S-Up>", ":m '<-2<CR>gvgv")
        vim.keymap.set("v", "<S-Down>", ":m '>+1<CR>gvgv")

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

        -- nvim-surround
        require("nvim-surround").setup({})

        -- nvim-cmp
        local cmp = require("cmp")
        cmp.setup({
          snippet = {
            expand = function(args)
              vim.fn["vsnip#anonymous"](args.body)
            end,
          },
          window = {
            completion = cmp.config.window.bordered(),
            -- documentation = cmp.config.window.bordered(),
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lua", keyword_length = 2 },
            { name = "nvim_lsp", keyword_length = 5 },
            { name = "vsnip", keyword_length = 5 },
            { name = "path", keyword_length = 1 },
          }, {
            { name = "buffer", keyword_length = 5 },
          }),
          formatting = {
            format = require("lspkind").cmp_format {
              with_text = true,
              menu = {
                buffer = "[buf]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[api]",
                path = "[path]",
                vsnip = "[snip]",
              },
            },
          },
        })

        -- oil-nvim
        require("oil").setup({
          default_file_explorer = true,
          delete_to_trash = false,
          skip_confirm_for_simple_edits = true,
          columns = {
            "icon",
            "permissions",
          },
          view_options = {
            show_hidden = true,
            natural_order = true,
            is_always_hidden = function(name, _)
              return name == '..'
            --   return name == '..' or name == '.git'
            end,
          },
          win_options = {
            wrap = true,
          }
        })

        vim.keymap.set("n", "-", "<cmd>Oil<cr>", {desc = "Open parent directory"})

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

        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        local lspconfig = require("lspconfig")
        lspconfig.cssls.setup({ capabilities = capabilities, })
        lspconfig.eslint.setup({ capabilities = capabilities, })
        lspconfig.gopls.setup({ capabilities = capabilities, })
        lspconfig.html.setup({ capabilities = capabilities, })
        lspconfig.jsonls.setup({ capabilities = capabilities, })
        lspconfig.lua_ls.setup({ capabilities = capabilities, })
        lspconfig.marksman.setup({ capabilities = capabilities, })
        lspconfig.terraformls.setup({ capabilities = capabilities, })

        -- rust
        lspconfig.rust_analyzer.setup({
          capabilities = capabilities,
          cmd = { "${pkgs.rust-analyzer}/bin/rust-analyzer" },
          settings = {
              ["rust-analyzer"] = {
                  imports = {
                      granularity = {
                          group = "module",
                      },
                      prefix = "self",
                  },
                  cargo = {
                      buildScripts = {
                          enable = true,
                      },
                  },
                  procMacro = {
                      enable = true
                  },
              }
          },
          single_file_support = true,
        })

        -- elixir
        lspconfig.elixirls.setup({
          capabilities = capabilities,
          cmd = { "${pkgs.elixir-ls}/bin/elixir-ls" },
        })

        -- nix
        lspconfig.nixd.setup({
          autostart = true,
          capabilities = capabilities,
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
          capabilities = capabilities,
          cmd = { "${pkgs.nil}/bin/nil" },
          settings = {
            ['nil'] = {
              formatting = {
                command = { "${pkgs.alejandra}/bin/alejandra" },
              },
            },
          },
        })

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
  };
}
