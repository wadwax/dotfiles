local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = "50" })
  end,
})

-- Remove whitespace on save
autocmd("BufWritePre", {
  pattern = "*",
  command = ":%s/\\s\\+$//e",
})

-- Don't auto comment new lines
autocmd("BufEnter", {
  pattern = "*",
  command = "set fo-=c fo-=r fo-=o",
})

-- Settings for filetypes:
-- Disable line length marker
augroup("setLineLength", { clear = true })
autocmd("Filetype", {
  group = "setLineLength",
  pattern = { "text", "markdown", "html", "xhtml", "javascript", "typescript" },
  command = "setlocal cc=0",
})

-- Set indentation to 2 spaces
augroup("setIndent", { clear = true })
autocmd("Filetype", {
  group = "setIndent",
  pattern = { "xml", "html", "xhtml", "css", "scss", "javascript", "typescript",
    "yaml", "lua"
  },
  command = "setlocal shiftwidth=2 tabstop=2",
})

-- Terminal settings:
-- Open a Terminal on the right tab
autocmd("CmdlineEnter", {
  command = "command! Term :botright vsplit term://$SHELL",
})

-- Enter insert mode when switching to terminal
autocmd("TermOpen", {
  command = "setlocal listchars= nonumber norelativenumber nocursorline",
})

autocmd("TermOpen", {
  pattern = "*",
  command = "startinsert",
})

-- Close terminal buffer on process exit
autocmd("BufLeave", {
  pattern = "term://*",
  command = "stopinsert",
})

-- Auto-reload files when changed externally
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  command = "if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif",
})

-- Notification after file change
autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.WARN)
  end,
})

-- PDF and Image preview
augroup("FilePreview", { clear = true })

-- Detect OS for appropriate open command
local function get_open_cmd()
  if vim.fn.has("mac") == 1 then
    return "open"
  elseif vim.fn.has("unix") == 1 then
    return "xdg-open"
  elseif vim.fn.has("win32") == 1 then
    return "cmd.exe /c start"
  end
  return nil
end

-- Open PDFs with default viewer
autocmd("BufReadCmd", {
  group = "FilePreview",
  pattern = "*.pdf",
  callback = function(args)
    local filepath = vim.fn.expand("<afile>:p")
    local open_cmd = get_open_cmd()
    if open_cmd then
      if vim.fn.has("win32") == 1 then
        vim.fn.jobstart(open_cmd .. " " .. vim.fn.shellescape(filepath), {detach = true})
      else
        vim.fn.jobstart({open_cmd, filepath}, {detach = true})
      end
      vim.api.nvim_buf_delete(args.buf, {force = true})
    else
      vim.notify("Cannot open PDF: unsupported platform", vim.log.levels.ERROR)
    end
  end,
})

-- Fallback for images if image.nvim doesn't work
-- (can be disabled if image.nvim works well)
autocmd("BufReadCmd", {
  group = "FilePreview",
  pattern = {"*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp"},
  callback = function(args)
    local filepath = vim.fn.expand("<afile>:p")
    -- Try to let image.nvim handle it first
    local has_image_nvim = pcall(require, "image")
    if not has_image_nvim then
      -- Fallback to external viewer
      local open_cmd = get_open_cmd()
      if open_cmd then
        if vim.fn.has("win32") == 1 then
          vim.fn.jobstart(open_cmd .. " " .. vim.fn.shellescape(filepath), {detach = true})
        else
          vim.fn.jobstart({open_cmd, filepath}, {detach = true})
        end
        vim.api.nvim_buf_delete(args.buf, {force = true})
      else
        vim.notify("Cannot open image: unsupported platform", vim.log.levels.ERROR)
      end
    end
  end,
})

