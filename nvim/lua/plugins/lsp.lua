local set = vim.keymap.set
local lsp_zero = require("lsp-zero")
local lsp_config = require("lspconfig")

local on_attach = function(client, bufnr)
	local opts = { buffer = bufnr }

	if client.name == "lua_ls" then
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = "*.lua",
			callback = function()
				require("stylua").format()
			end,
		})
	end

	set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
	set("n", "<leader>r", vim.lsp.buf.rename, opts)
	set("n", "K", vim.lsp.buf.hover, opts)
	set("n", "gd", vim.lsp.buf.definition, opts)
	set("n", "gn", vim.diagnostic.goto_next, opts)
	set("n", "gp", vim.diagnostic.goto_prev, opts)
	set({ "n", "v", "x" }, "ga", vim.lsp.buf.code_action, opts)
end

local rust_analyzer_config = function()
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
					disabled = {
						"inactive-code",
						"unlinked-file",
					},
				},
				completion = {
					postfix = {
						enable = false,
					},
				},
				rustfmt = {
					overrideCommand = {
						"leptosfmt",
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
end

return {
	{
		"j-hui/fidget.nvim",
		opts = {},
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
					["taplo"] = { "toml" },
					["rust_analyzer"] = { "rust" },
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
			return {
				handlers = {
					lsp_zero.default_setup,
					rust_analyzer = rust_analyzer_config,
				},
			}
		end,
	},
}
