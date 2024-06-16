---@type LazyPluginSpec[]
return {
    {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            require("hardtime").setup({
                disabled_keys = {
                    ["<Up>"] = {},
                    ["<Down>"] = {},
                },
                max_count = 3,
                disable_mouse = false,
            })

            local state = true;
            local msg

            if state then
                msg = "ENABLED"
            else
                msg = "DISABLED"
            end
            vim.keymap.set("n", "<leader>z", function()
                vim.cmd("Hardtime toggle")
                vim.notify("Hardtime toggled" .. msg)
            end)
        end,
    },
    { "tpope/vim-surround" },
    { "christoomey/vim-tmux-navigator" },
    { "tpope/vim-repeat" },


    {
        "tpope/vim-fugitive",
        lazy = false,
        keys = {
            { "<leader>t", "<cmd>:vertical :Git<cr>" },
        },
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            defaults = {
                border = true,
                layout_strategy = "horizontal",
                wrap_results = false,
                sorting_strategy = "ascending",
                layout_config = {
                    horizontal = {
                        height = 0.9,
                        preview_cutoff = 120,
                        prompt_position = "top",
                        width = 0.9,
                    },
                },
            },
        },
        config = function(_, opts)
            require("telescope").setup(opts)
            local tele = require("telescope.builtin")

            local setnl = function(arg, f)
                vim.keymap.set("n", "<leader>" .. arg, f)
            end

            setnl("=", tele.spell_suggest)
            setnl("T", tele.treesitter)
            setnl("a", tele.autocommands)
            setnl("b", tele.buffers)
            setnl("d", tele.diagnostics)
            setnl("f", tele.find_files)
            setnl("g", tele.live_grep)
            setnl("h", tele.help_tags)
            setnl('"', tele.registers)
            setnl("m", tele.marks)
            setnl("R", tele.lsp_references)
            setnl("s", tele.lsp_dynamic_workspace_symbols)
            setnl("H", function()
                tele.find_files({
                    hidden = true,
                    no_ignore = true,
                    no_ignore_parent = true,
                })
            end)
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function(_, _)
            require("nvim-treesitter.configs").setup({
                modules = {},
                ignore_install = {},
                auto_install = true,
                ensure_installed = {
                    -- for some reason markdown_inline doesnt auto_install
                    -- rust doc comments maybe that is a bug worth putting in their github.
                    "markdown_inline",
                    "markdown",
                },
                sync_install = false,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
    },

    {
        "stevearc/oil.nvim",
        opts = {},
        keys = {
            { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
        },
    },
}
