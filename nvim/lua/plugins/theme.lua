---@type LazyPluginSpec[]
return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        init = function()
            vim.cmd.colorscheme("catppuccin")
        end,
        opts = {
            integrations = {
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "bold" },
                        hints = { "bold" },
                        warnings = { "bold" },
                        information = { "bold" },
                    },
                },
            },
            custom_highlights = function(colors)
                return {
                    LineNr = { fg = colors.maroon, style = { "bold", "italic" } },
                }
            end,
        },
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
