{
  config,
  lib,
  pkgs,
  ...
}: let
  markdown_config = pkgs.writeText "config.json" (
    builtins.toJSON {
      "default" = true;
      "MD007" = {
        "indent" = 4;
        "start_indent" = 4;
      };
      "MD013" = {
        "tables" = false;
      };
      "MD025" = false;
      "MD029" = {
        "style" = "one_or_ordered";
      };
      "MD041" = false;
    }
  );
in {
  imports = [];

  options = {
    custom.user.editors.neovim.enable = lib.mkEnableOption "neovim" // {default = true;};
  };

  config = lib.mkIf (config.custom.user.editors.enable && config.custom.user.editors.neovim.enable) {
    home = {
      packages =
        builtins.attrValues
        {
          inherit
            (pkgs)
            cargo
            elixir-ls
            gopls
            lua-language-server
            marksman
            nil
            nixd
            terraform-ls
            vscode-langservers-extracted
            rust-analyzer
            rustc
            rustfmt
            ;
          inherit
            (pkgs.python312Packages)
            python-lsp-server
            pyls-isort
            pylsp-mypy
            python-lsp-black
            python-lsp-jsonrpc
            python-lsp-ruff
            ;
        };
    };

    programs.neovim = {
      enable = true;
      plugins = builtins.attrValues {
        inherit
          (pkgs.vimPlugins)
          CopilotChat-nvim
          avante-nvim
          bigfile-nvim
          cmp-nvim-lsp
          cmp-nvim-lua
          cmp-path
          cmp-vsnip
          comment-nvim
          conform-nvim
          diffview-nvim
          gitsigns-nvim
          lspkind-nvim
          lualine-nvim
          neogit
          nord-nvim
          nui-nvim
          nvim-cmp
          nvim-lastplace
          nvim-lspconfig
          nvim-surround
          nvim-treesitter
          nvim-web-devicons
          oil-nvim
          telescope-live-grep-args-nvim
          telescope-nvim
          telescope-ui-select-nvim
          tmux-nvim
          undotree
          vim-vsnip
          vim-vsnip-integ
          which-key-nvim
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
          python
          terraform
          vimdoc
          yaml
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

        -- disable persistent search highlighting after a search is complete
        vim.opt.hlsearch = false

        -- keep 10 lines visible above/below cursor when scrolling
        vim.opt.scrolloff = 10
        vim.g.mapleader = ' '

        -- completion settings
        -- vim.opt.completeopt = "menuone,noinsert,popup"  -- Improve completion behavior

        -- personal keybinds
        vim.keymap.set("n", "<leader>w\\", "<cmd>vsplit<cr>")
        vim.keymap.set("n", "<leader>ws", "<cmd>split<cr>")
        vim.keymap.set("n", "<leader>qq", "<cmd>quit<cr>")
        vim.keymap.set("n", "<leader>QQ", "<cmd>quit!<cr>")
        vim.keymap.set("n", "<leader>zz", "<cmd>wq<cr>")
        vim.keymap.set("n", "<leader>wx", "<C-W>x")

        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
        vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_prev)
        vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_next)
        vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

        -- move visual selection up and down
        vim.keymap.set("v", "<S-Up>", ":m '<-2<CR>gvgv")
        vim.keymap.set("v", "<S-Down>", ":m '>+1<CR>gvgv")

        vim.keymap.set('n', "<leader>U", vim.cmd.UndotreeToggle)
        vim.keymap.set('n', "<leader>n", vim.cmd.Neogit)

        -- neogit
        require("neogit").setup({
          disable_context_highlighting = true
        })

        -- bigfile
        require("bigfile").setup({
          filesize = 10, -- size of the file in MiB, the plugin round file sizes to the closest MiB
          pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
          features = { -- features to disable
            "indent_blankline",
            "illuminate",
            "lsp",
            "treesitter",
            "syntax",
            "matchparen",
            "vimopts",
            "filetype",
          },
        })

        -- CopilotChat
        require("CopilotChat").setup({
          mappings = {
            reset = {
              normal = '<C-S-r>',
              insert = '<C-S-r>'
            }
          }
        })

        -- avante
        require("avante").setup({
          provider = "ollama",
          providers = {
            ollama = {
              endpoint = "http://127.0.0.1:11434",
              model = "qwen3:32b",
            },
          },
        })

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

        -- conform-nvim
        require("conform").setup({
          formatters_by_ft = {
            markdown = { "markdownlint" },
            nix = { "alejandra" },
            python = { "isort", "black" },
          },
          formatters = {
            alejandra = {
              command = "${pkgs.alejandra}/bin/alejandra",
            },
            black = {
              command = "${pkgs.black}/bin/black",
            },
            isort = {
              command = "${pkgs.isort}/bin/isort",
            },
            markdownlint = {
              command = "${pkgs.markdownlint-cli}/bin/markdownlint",
              args = {
                "--config",
                "${markdown_config}",
                "--fix",
                "$FILENAME",
              },
              exit_codes = { 0, 1}, -- code 1 is given when trying a file that includes non-autofixable errors
              stdin = false,
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
        require("telescope").setup({
          extensions = {
            live_grep_args = {
              auto_quoting = true,
              mappings = {
                i = {
                  ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
                  ["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt({
                    postfix = " --iglob "
                  }),
                  -- freeze the current list and start a fuzzy search in the frozen list
                  ["<C-space>"] = require("telescope.actions").to_fuzzy_refine,
                }
              }
            },
            ['ui-select'] = {
              require("telescope.themes").get_dropdown({})
            }
          }
        })

        vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
        vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
        vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
        vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
        vim.keymap.set("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>")
        vim.keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>")
        vim.keymap.set("n", "<leader>fw", "<cmd>Telescope grep_string<cr>")

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

        vim.keymap.set("n", "<C-k>", "<cmd>lua require('tmux').move_top()<cr>")
        vim.keymap.set("n", "<C-j>", "<cmd>lua require('tmux').move_bottom()<cr>")
        vim.keymap.set("n", "<C-h>", "<cmd>lua require('tmux').move_left()<cr>")
        vim.keymap.set("n", "<C-l>", "<cmd>lua require('tmux').move_right()<cr>")

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

        -- pylsp
        lspconfig.pylsp.setup({
          capabilities = capabilities,
          on_attach = custom_attach,
          flags =  {
            debounce_text_changes = 200,
          },
          settings = {
            pylsp = {
              formatting = {
                command = { "${pkgs.black}/bin/black" },
              },
              plugins = {
                -- formatter options
                black = { enabled = true},
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                -- linter options
                pylint = { enabled = true, executable = "${pkgs.pylint}/bin/pylint" },
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
                -- type checker
                pylsp_mypy = { enabled = true },
                -- auto-completion options
                jedi_completion = { fuzzy = true },
                -- import sorting
                pyls_isort = { enabled = true },
              }
            }
          }
        })

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
            -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
            -- vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
            vim.keymap.set("n", "<leader>Wa", vim.lsp.buf.add_workspace_folder, opts)
            vim.keymap.set("n", "<leader>Wr", vim.lsp.buf.remove_workspace_folder, opts)
            vim.keymap.set("n", "<leader>Wl", function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts)
            vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
            vim.keymap.set({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

            -- conform-nvim format
            vim.keymap.set({"n", "v"}, "<leader>F", function()
              require("conform").format({
                async = false,
                lsp_fallback = true,
                timeout_ms = 1000,
              })
            end, opts)

            -- traditional vsp style buffering disabled, we use conform-nvim
            -- vim.keymap.set("n", "<leader>F", function()
            --   vim.lsp.buf.format { async = true }
            -- end, opts)
          end,
        })

      '';
    };
  };
}
