-- Initialize lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup({
  { "catppuccin/nvim",        name = "catppuccin",     priority = 1000 },
  {
    "EdenEast/nightfox.nvim",
    name = "nightfox",
    priority = 1000
  }, -- File explorer
  {
    "goolord/alpha-nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local startify = require("alpha.themes.startify")
      startify.file_icons.provider = "devicons"
      require("alpha").setup(startify.config)
    end
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim",              -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_by_name = {
            '.git'
          }
        }
      }
    }
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      telescope.setup()
    end
  }, -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "vim", "javascript", "typescript", "tsx",
          "rust", "python", "dockerfile", "yaml", "toml",
          "json", "css", "html", "markdown", "bash"
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false
        },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
      })
    end
  }, -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "rust_analyzer",
          "ts_ls",
          "pyright",
          "tailwindcss",
          "jsonls",
          "yamlls",
        },
      })

      -- Configure LSP diagnostics
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = 'always',
        },
      })

      -- LSP diagnostic signs
      local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- Rust
      vim.lsp.config.rust_analyzer = {
        cmd = { 'rust-analyzer' },
        filetypes = { 'rust' },
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            checkOnSave = { command = "clippy" },
          },
        },
      }

      -- TypeScript
      vim.lsp.config.ts_ls = {
        cmd = { 'typescript-language-server', '--stdio' },
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        capabilities = capabilities,
      }

      -- Python
      vim.lsp.config.pyright = {
        cmd = { 'pyright-langserver', '--stdio' },
        filetypes = { 'python' },
        capabilities = capabilities,
      }

      -- Tailwind CSS
      vim.lsp.config.tailwindcss = {
        cmd = { 'tailwindcss-language-server', '--stdio' },
        filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
        capabilities = capabilities,
      }

      -- JSON
      vim.lsp.config.jsonls = {
        cmd = { 'vscode-json-languageserver', '--stdio' },
        filetypes = { 'json', 'jsonc' },
        capabilities = capabilities,
      }

      -- YAML
      vim.lsp.config.yamlls = {
        cmd = { 'yaml-language-server', '--stdio' },
        filetypes = { 'yaml', 'yaml.docker-compose' },
        capabilities = capabilities,
      }
    end
  }, -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })

      -- Set up lspconfig with cmp capabilities
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Update LSP configs to use completion capabilities
      for server_name, config in pairs({
        rust_analyzer = vim.lsp.config.rust_analyzer,
        ts_ls = vim.lsp.config.ts_ls,
        pyright = vim.lsp.config.pyright,
        tailwindcss = vim.lsp.config.tailwindcss,
        jsonls = vim.lsp.config.jsonls,
        yamlls = vim.lsp.config.yamlls,
      }) do
        if config then
          config.capabilities = capabilities
        end
      end
    end,
  }, -- AI Inline Completion
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require('minuet').setup({
        provider = 'claude',
        request_timeout = 30,        -- 30 second timeout for Claude API
        context_window = 1024,       -- Context size (start conservative)
        n_completions = 1,           -- Number of suggestions

        provider_options = {
          claude = {
            model = 'claude-3-5-sonnet-20241022',
            stream = true,
            api_key = 'ANTHROPIC_API_KEY',
            end_point = 'https://api.anthropic.com/v1/messages',
            optional = {
              max_tokens = 256,      -- Conservative default per docs
            },
          },
        },

        virtualtext = {
          enabled = true,
          manual = false,
          auto_trigger_ft = {},          -- Empty = ALL filetypes
          keymap = {
            accept = '<C-j>',            -- Accept full completion
            accept_line = '<C-l>',       -- Accept one line
            prev = '<C-[>',              -- Previous suggestion
            next = '<C-]>',              -- Next suggestion
            dismiss = '<C-x>',           -- Dismiss suggestion
          },
        },

        -- Performance settings
        throttle = 1000,               -- Rate limiting
        debounce = 500,                -- Wait before triggering
      })
    end,
  }, -- Git
  { "tpope/vim-fugitive" }, -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      theme = "catppuccin",
      sections = {
        lualine_a = {"mode"},
        lualine_b = {"branch", "diff", "diagnostics"},
        lualine_c = {"filename"},
        lualine_x = {"encoding", "fileformat", "filetype"},
        lualine_y = {"progress"},
        lualine_z = {"location"}
      },
    },
  }, -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true
  }, -- Comments
  {
    "numToStr/Comment.nvim",
    config = true
  },                        -- Emmet
  { "mattn/emmet-vim" },    -- Language specific
  {
    "styled-components/vim-styled-components",
    branch = "main"
  }, { "jparise/vim-graphql" }, { "pangloss/vim-javascript" }, { "MaxMEllon/vim-jsx-pretty" }, { "HerringtonDarkholme/yats.vim" },
  { "ap/vim-css-color" }, { "evanleck/vim-svelte" }, { "jvirtanen/vim-hcl" }, -- PlantUML
  {
    "aklt/plantuml-syntax",
    dependencies = { "tyru/open-browser.vim", "weirongxu/plantuml-previewer.vim" }
  }, -- Documentation
  {
    "kkoomen/vim-doge",
    build = ":call doge#install()"
  }, -- Development workflow plugins
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    opts = {
      open_mapping = [[<c-\>]],
      direction = "horizontal",
      size = 20,
    },
  }, -- Tmux integration
  { "christoomey/vim-tmux-navigator" },

  -- Claude Code plugin
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = function()
      require("claudecode").setup({
        track_selection = true,
        visual_demotion_delay_ms = 50,
        focus_after_send = true,
      })

      -- Override <C-h> when in Claude terminal to close it instead of tmux navigation
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "claudecode",
        callback = function()
          vim.keymap.set("n", "<C-h>", "<cmd>ClaudeCode<cr>", { buffer = true, desc = "Close Claude" })
          vim.keymap.set("i", "<C-h>", "<cmd>ClaudeCode<cr>", { buffer = true, desc = "Close Claude" })
        end,
      })
    end,
    keys = {
    { "<leader>a", nil, desc = "AI/Claude Code" },
    { "<C-t>", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
    },
    -- Diff management
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
  },

})
