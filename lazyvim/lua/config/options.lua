-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Use system clipboard for all yank, delete, change and put operations
vim.opt.clipboard = "unnamedplus"

-- Disable folding in markdown files (fixes code block visibility issue)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.foldenable = false
  end,
})
