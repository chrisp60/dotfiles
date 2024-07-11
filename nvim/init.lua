vim.g.mapleader = " "

-- Bootstrap Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

vim.lsp.set_log_level("ERROR")
vim.opt.colorcolumn = "80,100"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.showmode = true
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.wrap = false
vim.opt.numberwidth = 4

vim.api.nvim_create_autocmd({ "BufWritePre", "BufWrite" }, {
	pattern = { "*.js", "*.html" },
	callback = function()
		vim.keymap.set("n", "<leader>p", "<cmd>silent %! prettierd %<cr>")
	end,
})

vim.diagnostic.config({
	virtual_text = false,
	update_in_insert = true,
	signs = true,
	underline = false,
})

local showing_virtual_text = false

vim.keymap.set("n", "<leader>It", function()
	showing_virtual_text = not showing_virtual_text
	vim.diagnostic.config({ virtual_text = showing_virtual_text })
end)

-- Do not show hot-reload messages from Lazy
require("lazy").setup("plugins", {
	dev = {
		path = "~/projects",
		pattern = ".nvim",
        fallback = false,
	},
	change_detection = {
		notify = false,
	},
})
