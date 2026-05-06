{
  flake.modules.homeManager."features-neovim" =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.bash-language-server
        pkgs.clang-tools
        pkgs.fd
        pkgs.fzf
        pkgs.lazygit
        pkgs.lua-language-server
        pkgs.marksman
        pkgs.nil
        pkgs.nixd
        pkgs.pyright
        pkgs.ripgrep
        pkgs.rust-analyzer
        pkgs.shfmt
        pkgs.stylua
        pkgs.typescript-language-server
        pkgs.vscode-langservers-extracted
        pkgs.yaml-language-server
      ];

      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;

        plugins = with pkgs.vimPlugins; [
          cmp-buffer
          cmp-nvim-lsp
          cmp-path
          cmp_luasnip
          comment-nvim
          fidget-nvim
          gitsigns-nvim
          indent-blankline-nvim
          luasnip
          nvim-autopairs
          nvim-cmp
          nvim-lspconfig
          nvim-surround
          nvim-web-devicons
          plenary-nvim
          telescope-fzf-native-nvim
          telescope-nvim
          todo-comments-nvim
          trouble-nvim
          vim-sleuth
          which-key-nvim
          (nvim-treesitter.withPlugins (
            parsers: with parsers; [
              bash
              c
              cpp
              css
              html
              javascript
              json
              lua
              markdown
              markdown_inline
              nix
              python
              rust
              toml
              tsx
              typescript
              vim
              vimdoc
              yaml
            ]
          ))
        ];

        extraLuaConfig = ''
          vim.g.mapleader = " "
          vim.g.maplocalleader = " "

          vim.opt.number = true
          vim.opt.relativenumber = true
          vim.opt.signcolumn = "yes"
          vim.opt.cursorline = true
          vim.opt.termguicolors = true
          vim.opt.splitbelow = true
          vim.opt.splitright = true
          vim.opt.ignorecase = true
          vim.opt.smartcase = true
          vim.opt.updatetime = 250
          vim.opt.timeoutlen = 400
          vim.opt.undofile = true
          vim.opt.expandtab = true
          vim.opt.shiftwidth = 2
          vim.opt.tabstop = 2

          local map = vim.keymap.set
          map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
          map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })
          map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit window" })
          map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close buffer" })
          map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
          map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })

          require("nvim-surround").setup()
          require("nvim-autopairs").setup()
          require("Comment").setup()
          require("gitsigns").setup()
          require("fidget").setup()
          require("todo-comments").setup()
          require("trouble").setup()
          require("ibl").setup()

          local wk = require("which-key")
          wk.setup()
          if wk.add then
            wk.add({
              { "<leader>b", group = "buffers" },
              { "<leader>f", group = "find" },
              { "<leader>g", group = "git" },
              { "<leader>l", group = "lsp" },
              { "<leader>t", group = "trouble" },
            })
          else
            wk.register({
              b = { name = "buffers" },
              f = { name = "find" },
              g = { name = "git" },
              l = { name = "lsp" },
              t = { name = "trouble" },
            }, { prefix = "<leader>" })
          end

          require("nvim-treesitter.configs").setup({
            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
              enable = true,
              keymaps = {
                init_selection = "<C-space>",
                node_incremental = "<C-space>",
                scope_incremental = "<C-s>",
                node_decremental = "<M-space>",
              },
            },
          })

          local telescope = require("telescope")
          telescope.setup({
            defaults = {
              mappings = {
                i = {
                  ["<C-j>"] = "move_selection_next",
                  ["<C-k>"] = "move_selection_previous",
                },
              },
            },
          })
          pcall(telescope.load_extension, "fzf")

          local builtin = require("telescope.builtin")
          map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
          map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
          map("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
          map("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })
          map("n", "<leader>fk", builtin.keymaps, { desc = "Find keymaps" })
          map("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
          map("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
          map("n", "<leader>gs", builtin.git_status, { desc = "Git status" })
          map("n", "<leader>gg", function()
            vim.cmd("tabnew")
            vim.cmd("terminal lazygit")
            vim.cmd("startinsert")
          end, { desc = "Lazygit" })

          map("n", "<leader>td", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics" })
          map("n", "<leader>ts", "<cmd>Trouble symbols toggle<CR>", { desc = "Symbols" })
          map("n", "<leader>tq", "<cmd>Trouble quickfix toggle<CR>", { desc = "Quickfix" })

          local cmp = require("cmp")
          local luasnip = require("luasnip")
          cmp.setup({
            snippet = {
              expand = function(args)
                luasnip.lsp_expand(args.body)
              end,
            },
            mapping = cmp.mapping.preset.insert({
              ["<C-b>"] = cmp.mapping.scroll_docs(-4),
              ["<C-f>"] = cmp.mapping.scroll_docs(4),
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<CR>"] = cmp.mapping.confirm({ select = true }),
              ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                else
                  fallback()
                end
              end, { "i", "s" }),
              ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
              { name = "nvim_lsp" },
              { name = "luasnip" },
              { name = "path" },
            }, {
              { name = "buffer" },
            }),
          })

          local capabilities = require("cmp_nvim_lsp").default_capabilities()
          local lspconfig = require("lspconfig")
          local servers = {
            bashls = {},
            clangd = {},
            cssls = {},
            html = {},
            jsonls = {},
            lua_ls = {
              settings = {
                Lua = {
                  diagnostics = { globals = { "vim" } },
                  workspace = { checkThirdParty = false },
                },
              },
            },
            marksman = {},
            nil_ls = {},
            nixd = {},
            pyright = {},
            rust_analyzer = {},
            ts_ls = {},
            yamlls = {},
          }

          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local opts = { buffer = args.buf }
              map("n", "gd", builtin.lsp_definitions, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
              map("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
              map("n", "gr", builtin.lsp_references, vim.tbl_extend("force", opts, { desc = "References" }))
              map("n", "gi", builtin.lsp_implementations, vim.tbl_extend("force", opts, { desc = "Implementations" }))
              map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
              map("n", "<leader>lr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
              map("n", "<leader>la", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
              map("n", "<leader>lf", function()
                vim.lsp.buf.format({ async = true })
              end, vim.tbl_extend("force", opts, { desc = "Format" }))
              map("n", "<leader>ls", builtin.lsp_document_symbols, vim.tbl_extend("force", opts, { desc = "Document symbols" }))
              map("n", "<leader>lS", builtin.lsp_dynamic_workspace_symbols, vim.tbl_extend("force", opts, { desc = "Workspace symbols" }))
            end,
          })

          for server, config in pairs(servers) do
            config.capabilities = capabilities
            lspconfig[server].setup(config)
          end

          vim.diagnostic.config({
            virtual_text = { source = "if_many", prefix = "*" },
            severity_sort = true,
            float = { source = "always" },
          })
        '';
      };
    };
}
