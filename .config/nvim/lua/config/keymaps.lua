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



-- Buffer navigation
map("n", "<leader>y", ":.w! ~/.vimbuffer<CR>", { silent = true })
map("v", "<leader>y", ":w! ~/.vimbuffer<CR>", { silent = true })
map("n", "<leader>p", ":r ~/.vimbuffer<CR>", { silent = true })

-- Neotree
map('n', "<C-n>", "<cmd>Neotree toggle<CR>", { silent = true })

-- Claude pane
map('n', "<C-t>", "<cmd>lua require('claude-pane').toggle()<CR>", { silent = true })
map('v', "<C-t>", "<cmd>lua require('claude-pane').toggle()<CR>", { silent = true, noremap = true })
map('n', "<leader>cc", "<cmd>lua require('claude-pane').focus()<CR>", { silent = true })


-- Native LSP keybindings
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { silent = true })
map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { silent = true })
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { silent = true })
map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { silent = true })
map('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { silent = true })
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { silent = true })
map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { silent = true })
map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { silent = true })
map('v', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', { silent = true })
map('n', '<leader>f', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', { silent = true })
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { silent = true })
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { silent = true })
map('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { silent = true })
map('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', { silent = true })


