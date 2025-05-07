local map = vim.keymap.set

-- Escape mapping
map("i", "__", "<ESC>", { silent = true })
map("v", "__", "<ESC>", { silent = true })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { silent = true })
map("n", "<C-j>", "<C-w>j", { silent = true })
map("n", "<C-k>", "<C-w>k", { silent = true })
map("n", "<C-l>", "<C-w>l", { silent = true })

-- Better indenting
map("v", "<", "<gv", { silent = true })
map("v", ">", ">gv", { silent = true })

-- Move selected line / block of text in visual mode
-- map("v", "<C-j>", ":m '>+1<CR>gv=gv", { silent = true })
-- map("v", "<C-k>", ":m '<-2<CR>gv=gv", { silent = true })
-- map("i", "<C-j>", "<Esc>:m .+1<CR>==gi", { silent = true })
-- map("i", "<C-k>", "<Esc>:m .-2<CR>==gi", { silent = true })
-- map("n", "<C-j>", ":m .+1<CR>==", { silent = true })
-- map("n", "<C-k>", ":m .-2<CR>==", { silent = true })

-- Telescope mappings
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { silent = true })
map("n", "<leader>fg", "<cmd>Telescope git_files<CR>", { silent = true })
map("n", "<C-p>", "<cmd>Telescope git_files<CR>", { silent = true })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { silent = true })
map("n", "<leader>flg", "<cmd>Telescope live_grep<CR>", { silent = true })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { silent = true })

-- Git mappings
map("n", "<leader>gh", ":diffget //3<CR>", { silent = true })
map("n", "<leader>gu", ":diffget //2<CR>", { silent = true })
map("n", "<leader>gs", ":G<CR>", { silent = true })
map("n", "<leader>gc", ":Git commit<CR>", { silent = true })
map("n", "<leader>gp", ":Git push<CR>", { silent = true })

-- CoC mappings
map("n", "<C-f>", "<Plug>(coc-codeaction)", { silent = true })
map("n", "K", ":call v:lua.show_documentation()<CR>", { silent = true })
map("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
map("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })
map("n", "gd", "<Plug>(coc-definition)", { silent = true })
map("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
map("n", "gi", "<Plug>(coc-implementation)", { silent = true })
map("n", "gr", "<Plug>(coc-references)", { silent = true })
map("n", "<F2>", "<Plug>(coc-rename)", { silent = true })
map("n", "<ESC>", ":call coc#float#close_all()<CR>", { silent = true })
map("n", "<C-c>", ":call coc#float#close_all()<CR>", { silent = true })

-- Copilot
vim.g.copilot_no_tab_map = true
map("i", "<C-j>", "copilot#Accept('<CR>')", { silent = true, expr = true, script = true, replace_keycodes = false })

-- Buffer navigation
map("n", "<leader>y", ":.w! ~/.vimbuffer<CR>", { silent = true })
map("v", "<leader>y", ":w! ~/.vimbuffer<CR>", { silent = true })
map("n", "<leader>p", ":r ~/.vimbuffer<CR>", { silent = true })

-- Neotree
map('n', "<C-n>", "<cmd>Neotree toggle<CR>", { silent = true })

-- CoC completion
vim.cmd([[
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <C-x><C-z> coc#pum#visible() ? coc#pum#stop() : "\<C-x>\<C-z>"
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ v:lua.CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()
]])

-- Helper functions
_G.show_documentation = function()
  local filetype = vim.bo.filetype
  if vim.tbl_contains({ "vim", "help" }, filetype) then
    vim.cmd("h " .. vim.fn.expand("<cword>"))
  else
    vim.fn.CocActionAsync("doHover")
  end
end

_G.CheckBackspace = function()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end
