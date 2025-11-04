vim.g.mapleader = " "

local map = vim.keymap.set

map("n", "<leader>vs", vim.cmd.vsplit, { desc = "Split window vertically" })
map("n", "<leader>hs", vim.cmd.split, { desc = "Split window horizontally" })
map("n", "<leader>l", vim.cmd.Lazy, { desc = "Open Lazy" })
