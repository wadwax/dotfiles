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
  }, -- Tmux integration
  { "christoomey/vim-tmux-navigator" },

})
