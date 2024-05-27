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
                    LineNr = { fg = colors.overlay1, style = { "bold", "italic" } }
                }
            end,
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
