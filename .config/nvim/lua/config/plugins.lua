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
    -- dependencies = { 'echasnovski/mini.icons' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local startify = require("alpha.themes.startify")
      -- available: devicons, mini, default is mini
      -- if provider not loaded and enabled is true, it will try to use another provider
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
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "javascript", "typescript", "tsx" },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false
        }
      })
    end
  }, -- LSP and completion
  {
    "neoclide/coc.nvim",
    branch = "release"
  },                                                      -- Git
  { "tpope/vim-fugitive",     "airblade/vim-gitgutter" }, -- Status line
  { "vim-airline/vim-airline" },                          -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true
  }, -- Comments
  {
    "numToStr/Comment.nvim",
    config = true
  },                        -- Emmet
  { "mattn/emmet-vim" },    -- GitHub Copilot
  { "github/copilot.vim" }, -- Language specific
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
  }, -- Alpha (dashboard)
  {
    "goolord/alpha-nvim",
    config = function()
      require("alpha").setup(require("alpha.themes.dashboard").config)
    end
  }, -- Tmux integration
  { "christoomey/vim-tmux-navigator" },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = "*", -- set this to "*" if you want to always pull the latest change, false to update on release
    opts = {
      provider = "claude",
      auto_suggestions_provider = "copilot",
      hints = {
        enabled = false
      },
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true
      },
      windows = {
        position = "right",
        wrap = true,
        width = 30,
        sidebar_header = {
          enabled = false,
          align = "center"
        },
        input = {
          prefix = "> ",
          height = 8
        },
        edit = {
          border = "rounded",
          start_insert = true
        },
        ask = {
          floating = false,
          start_insert = true,
          border = "rounded",
          focus_on_apply = "ours"
        }
      },
      -- providers-setting
      claude = {
        model = "claude-3-5-sonnet-20240620", -- $3/$15, maxtokens=8000
        -- model = "claude-3-opus-20240229",  -- $15/$75
        -- model = "claude-3-haiku-20240307", -- $0.25/1.25
        max_tokens = 8000
      },
      copilot = {
        model = "gpt-4o-2024-05-13",
        -- model = "gpt-4o-mini",
        max_tokens = 4096
      },
      openai = {
        model = "gpt-4o", -- $2.5/$10
        -- model = "gpt-4o-mini", -- $0.15/$0.60
        max_tokens = 4096
      }
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = { "stevearc/dressing.nvim", "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "hrsh7th/nvim-cmp",            -- autocompletion for avante commands and mentions
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",      -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true
            },
            -- required for Windows users
            use_absolute_path = true
          }
        }
      }, {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" }
      },
      ft = { "markdown", "Avante" }
    } }
  },

})
