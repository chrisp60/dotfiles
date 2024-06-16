local set = vim.keymap.set

---@param client vim.lsp.Client
---@param bufnr integer
local on_attach = function(client, bufnr)
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "single",
    })
    local opts = { buffer = bufnr }
    local toks = vim.lsp.semantic_tokens
    local toks_supp = client.server_capabilities.semanticTokensProvider ~= nil
    local toks_on = toks_supp

    set("n", "<leader>S", function()
        if not toks_supp then
            vim.notify(client.name .. " does not support semantic tokens")
        elseif toks_on then
            vim.notify("disabling tokens")
            toks.stop(bufnr, client.id)
        else
            vim.notify("enabling tokens")
            toks.start(bufnr, client.id)
        end
        toks_on = not toks_on
    end, opts)

    set("n", "<leader>i", function()
        if client.server_capabilities.inlayHintProvider ~= nil then
            local hints_on = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
            if hints_on then
                vim.notify("hiding inlay hints")
            else
                vim.notify("showing inlay hints")
            end
            vim.lsp.inlay_hint.enable(not hints_on)
        else
            vim.notify(client.name .. " lsp does not support inlay hints")
        end
    end, opts)

    set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
    set("n", "<leader>r", vim.lsp.buf.rename, opts)
    set("n", "K", vim.lsp.buf.hover, opts)
    set("n", "gd", vim.lsp.buf.definition, opts)
    set("n", "gn", vim.diagnostic.goto_next, opts)
    set("n", "gp", vim.diagnostic.goto_prev, opts)
    set({ "n", "v", "x" }, "ga", vim.lsp.buf.code_action, opts)
end

return {
    {
        "j-hui/fidget.nvim",
        opts = {
            -- options
        },
    },
    {
        "rayliwell/tree-sitter-rstml",
        dependencies = { "nvim-treesitter" },
        ft = "rust",
        build = ":TSUpdate",
        name = "tree-sitter-rstml",
        opts = {},
    },
    {
        "j-hui/fidget.nvim",
        opts = {},
        enabled = true,
    },
    {
        "williamboman/mason.nvim",
        opts = {},
    },
    { "saadparwaiz1/cmp_luasnip" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "wesleimp/stylua.nvim" },

    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            { "folke/neodev.nvim", opts = {} },
        },
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "VonHeikemen/lsp-zero.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
        },
        opts = function()
            local cmp = require("cmp")
            local lsp_zero = require("lsp-zero")
            return {
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "nvim_lua" },
                },
                preselect = cmp.PreselectMode.None,
                mapping = {
                    ["<C-y>"] = cmp.mapping.complete({
                        config = {
                            sources = {
                                { name = "nvim_lsp" },
                            },
                        },
                    }),
                    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                    ["<C-l>"] = cmp.mapping.confirm({ select = true }),
                },
                formatting = lsp_zero.cmp_format({ details = true }),
                experimental = { ghost_text = false },
            }
        end,
    },

    {
        "VonHeikemen/lsp-zero.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        branch = "v3.x",
        config = function()
            local lsp_zero = require("lsp-zero")
            lsp_zero.format_on_save({
                servers = {
                    ["html"] = { "html" },
                    ["clangd"] = { "c" },
                    ["taplo"] = { "toml" },
                    ["rust_analyzer"] = { "rust" },
                    ["lua_ls"] = { "lua" },
                },
            })
            lsp_zero.on_attach(on_attach)
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "VonHeikemen/lsp-zero.nvim",
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = function()
            local lsp_zero = require("lsp-zero")
            local lsp_config = require("lspconfig")
            return {
                handlers = {
                    -- Handlers for everything else
                    lsp_zero.default_setup,
                    lua_ls = function()
                        lsp_config.lua_ls.setup({
                            settings = {
                                Lua = {
                                    completion = {
                                        callSnippet = "Replace",
                                        displayContext = 4,
                                        keywordSnippet = "Both",
                                    },
                                },
                            },
                        })
                    end,
                    rust_analyzer = function()
                        lsp_config.rust_analyzer.setup({
                            settings = {
                                ["rust-analyzer"] = {
                                    hover = {
                                        links = {
                                            enable = true,
                                        },
                                    },
                                    cargo = {
                                        features = "all",
                                    },
                                    diagnostics = {
                                        disabled = { "inactive-code", "unlinked-file" },
                                    },
                                    rustfmt = {
                                        overrideCommand = {
                                            "leptosfmt",
                                            "--max-width=80",
                                            "--tab-spaces=2",
                                            "--stdin",
                                            "--rustfmt",
                                        },
                                    },
                                    procMacro = {
                                        enabled = true,
                                        ignored = {
                                            tokio_macros = {
                                                "main",
                                                "test",
                                            },
                                            tracing_attributes = {
                                                "instrument",
                                            },
                                            serde_with_macros = {
                                                "serde_as",
                                            },
                                        },
                                    },
                                    imports = {
                                        prefix = "crate",
                                        granularity = {
                                            enforce = true,
                                        },
                                    },
                                    check = {
                                        command = "clippy",
                                        features = "all",
                                    },
                                },
                            },
                        })
                    end,
                },
            }
        end,
    },
}
