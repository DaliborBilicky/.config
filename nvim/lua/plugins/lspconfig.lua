return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local lspconfig = require("lspconfig")

		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local capabilities = cmp_nvim_lsp.default_capabilities()

		local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		local handlers = {
			["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
			["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
		}

		vim.diagnostic.config({
			float = { border = "rounded" },
			virtual_text = false,
		})

		lspconfig["clangd"].setup({
			capabilities = capabilities,
			handlers = handlers,
		})

		lspconfig["pyright"].setup({
			capabilities = capabilities,
			handlers = handlers,
		})

		local omnisharp_bin = vim.fn.stdpath("data") .. "/mason/packages/omnisharp/OmniSharp"

		lspconfig["omnisharp"].setup({
			cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
			root_dir = require("lspconfig.util").root_pattern("*.sln", "*.csproj", ".git"),
			capabilities = capabilities,
			handlers = handlers,
		})
	end,
}
