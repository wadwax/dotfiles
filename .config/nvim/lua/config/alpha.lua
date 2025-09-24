local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")
local header = [[

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⠶⠶⠛⠛⠛⠛⠓⠲⠶⢦⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣠⡴⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠶⣤⡀⠀⠀⠀⢀⣀⣀⡀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⣴⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢷⣤⡾⠛⠉⠉⠛⢷⣄⠀
⠀⠀⠀⠀⣰⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣷⡀⢠⠶⢦⠀⢹⡆
⠀⠀⢀⣾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡾⠋⠁⠀⠉⠛⢶⣄⠀⠀⠀⠀⠀⠀⠀⠈⢻⣎⠀⣸⠇⢸⡇
⠀⢀⣾⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠙⣧⡀⠀⠀⠀⠀⠀⠀⠀⢻⡿⠋⢀⣾⠃
⠀⣸⠿⠖⠀⠀⠀⠀⠀⠰⠿⠿⠷⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠈⣷⡀⠀⠀⠀⠀⠀⠀⠀⣿⡶⠟⠁⠀
⠀⣿⢦⡀⠀⠀⠀⠀⢀⡴⠶⣒⣲⢶⣄⠀⢻⣆⠀⠀⠀⠀⠀⠀⠀⠀⢸⣇⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀
⢸⣿⡏⣇⠀⠀⠀⢰⣏⣴⣿⣿⣿⣷⣜⣷⠀⢻⣦⡀⠀⠀⠀⠀⠀⠀⢸⡟⠀⠀⠀⠀⠀⠀⠀⠀⣧⠀⠀⠀
⢸⣿⡇⣿⠀⠀⠀⣸⢸⣿⣿⣿⣿⣿⣿⢸⠆⠀⠙⠿⣦⣄⣀⣀⣀⣠⡾⠁⠀⠀⠀⠀⠀⠀⠀⠀⡿⠀⠀⠀
⢸⣿⣷⣿⢿⣿⡿⠿⣦⡻⣿⣿⣿⡿⢏⡾⠀⠀⠀⠀⠀⠉⠙⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡇⠀⠀⠀
⠀⣯⡿⣹⣦⡏⠀⠀⠈⠻⣶⡶⠶⠶⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠇⠀⠀⠀
⠀⣿⠃⢀⣿⣿⡀⠀⠀⠀⠘⢷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡿⠀⠀⠀⠀
⠀⢿⣤⣼⣧⣼⣧⡀⠀⠀⣴⣾⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠿⠋⠀⠀⠀⠀⣸⠃⠀⠀⠀⠀
⠀⠈⢿⡙⢿⣄⣘⣿⡶⠶⠾⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡟⠁⠀⠀⠀⠀⠀⣴⠏⠀⠀⠀⠀⠀
⠀⠀⠈⠻⣦⣀⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣷⣀⠀⠀⠀⢀⣼⠏⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠙⢻⣶⣤⣄⣀⡀⠀⠀⣶⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣈⣽⢿⡄⠀⠈⣿⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠻⣦⡿⠉⠛⠛⠻⠿⣧⠀⢠⣿⠤⠤⠴⠶⠶⠿⣿⣿⠃⠘⣷⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣧⡼⠁⠀⠀⠀⠀⠀⠠⠖⠂⠀⠀⠘⠷⠟⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀   __   __   __ _  ____
⠀⠀⠀⠀⠀ _(  ) / _\ (  / )(  __)
⠀⠀⠀⠀⠀/ \) \/    \ )  (  ) _)
⠀⠀⠀⠀⠀\____/\_/\_/(__\_)(____)
]]

-- Define a list of colors
local colors = { {
  fg = "#ff90bf"
}, -- Hanni
  {
    fg = "#AFE1AF"
  }, -- Minji
  {
    fg = "#FFC300"
  }, -- Danielle
  {
    fg = "#FFFFFF"
  }, -- Haerin
  {
    fg = "#41b5ff"
  } -- Hyein
}

-- Current color index
local current_color_index = 1

-- Function to set a random color
local function set_random_color()
  math.randomseed(os.time())

  -- Select a random color index
  local random_index = math.random(1, #colors)

  -- Get the random color
  local color = colors[random_index]

  -- Set the highlight group for the header
  vim.api.nvim_set_hl(0, "NewJeansHeader", {
    fg = color.fg
  })

  -- Update the header with the new highlight group
  dashboard.section.header.opts.hl = "NewJeansHeader"
end

-- Set header
dashboard.section.header.val = vim.split(header, "\n")

-- Call the function to set a random color
set_random_color()

-- Set menu
dashboard.section.buttons.val = { dashboard.button("i", "  > Start IDE",
  ":!tmux splitw -v -l 8 && tmux splitw -h && tmux selectp -t 1<CR>:e .<CR>"),
  dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
  dashboard.button("s", "  > Settings",
    ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"), dashboard.button("q", "󰩈  > Quit NVIM", ":qa<CR>") }

-- Send config to alpha
alpha.setup(dashboard.opts)

-- Disable folding on alpha buffer
vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])
