---@type LazyPluginSpec[]
return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        init = function()
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("ibl").setup({
                indent = { char = "▏" },
                scope = {
                    enabled = true,
                    show_start = true,
                },
            })
        end,
    },
    {
        "stevearc/dressing.nvim",
        opts = {},
    },
}
