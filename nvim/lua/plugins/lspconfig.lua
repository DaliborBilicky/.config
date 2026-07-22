return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()

		vim.diagnostic.config({
			float = { border = "rounded" },
			virtual_text = false,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = " ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
		})

		local handlers = {
			["textDocument/hover"] = function(err, result, ctx, config)
				config = config or {}
				config.border = "rounded"
				vim.lsp.handlers.hover(err, result, ctx, config)
			end,
			["textDocument/signatureHelp"] = function(err, result, ctx, config)
				config = config or {}
				config.border = "rounded"
				vim.lsp.handlers.signature_help(err, result, ctx, config)
			end,
		}

		vim.lsp.config("clangd", {
			capabilities = capabilities,
			handlers = handlers,
		})
		vim.lsp.enable("clangd")

		vim.lsp.config("pyright", {
			capabilities = capabilities,
			handlers = handlers,
		})
		vim.lsp.enable("pyright")

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = function()
				require("jdtls.jdtls_setup").setup()
			end,
		})
	end,
}
