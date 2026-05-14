vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.rnu = true
vim.opt.nu = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.laststatus = 3 -- global status line
vim.opt.foldmethod = "indent" -- if gets in the way, replace with expr or syntax
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.colorcolumn = "90"
vim.opt.modeline = false
vim.opt.exrc = true

vim.api.nvim_exec ('language en_US', true)

-- disable netrw at the very start
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
