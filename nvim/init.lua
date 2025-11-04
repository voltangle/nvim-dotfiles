require("voltangle.opts")
require("voltangle.keymaps")

-- bootstrap lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = "plugins",
	ui = {
		border = "rounded",
		size = {
			width = 0.8,
			height = 0.8,
		},
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function (ev)
        local nmap = function(keys, func, desc)
            if desc then
                desc = 'LSP: ' .. desc
            end

            vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = desc})
        end

        nmap("<leader>ca", function()
            vim.lsp.buf.code_action { context = {
                only = { 'quickfix', 'refactor', 'source'}}}
        end, 'Code Action')
        nmap("<leader>rn", vim.lsp.buf.rename, 'Rename')
    end
})

local swift_lsp = vim.api.nvim_create_augroup("swift_lsp", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "swift" },
	callback = function()
		local root_dir = vim.fs.dirname(vim.fs.find({
			"Package.swift",
			".git",
		}, { upward = true })[1])
		local client = vim.lsp.start({
			name = "sourcekit-lsp",
			cmd = { "sourcekit-lsp" },
			root_dir = root_dir,
		})
		vim.lsp.buf_attach_client(0, client)
	end,
	group = swift_lsp,
})

vim.cmd.colorscheme("catppuccin")
