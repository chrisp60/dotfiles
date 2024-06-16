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
vim.opt.swapfile = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.wrap = false
vim.opt.numberwidth = 2

vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter" }, {
    pattern = "*",
    command = "set rnu cursorline signcolumn=no numberwidth=1"
})

vim.diagnostic.config({
    virtual_text = false,
    update_in_insert = true,
    signs = true,
    underline = false,
})

local showing_virtual_text = false
local updating_on_insert = false

vim.keymap.set("n", "gvt", function()
    showing_virtual_text = not showing_virtual_text
    vim.diagnostic.config({ virtual_text = showing_virtual_text })
end)
vim.keymap.set("n", "goi", function()
    updating_on_insert = not updating_on_insert
    vim.diagnostic.config({ update_in_insert = updating_on_insert })
end)

-- Do not show hot-reload messages from Lazy
require("lazy").setup("plugins", {
    dev = {
        path = "~/projects",
        patterns = { "chrisp60" },
        fallback = false,
    },
    change_detection = {
        notify = false,
    },
})
