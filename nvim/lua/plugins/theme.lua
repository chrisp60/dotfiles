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
            highlight_overrides = {
                all = function(colors)
                    return {
                        -- ["@lsp.type.decorator"] = { fg = colors.blue },
                    }
                end,
            },
        },
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("ibl").setup({
                scope = {
                    enabled = true,
                    char = "╎",
                    show_start = true,
                },
                indent = { char = "╎" },
            })
        end,
    },


    {
        "stevearc/dressing.nvim",
        opts = {},
    },
}
