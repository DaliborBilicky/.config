return {
	"nvimtools/none-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local null_ls = require("null-ls")
		local helpers = require("null-ls.helpers")

		local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
		vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

		local tex_fmt_custom = {
			name = "tex-fmt",
			method = null_ls.methods.FORMATTING,
			filetypes = { "tex" },
			generator = helpers.formatter_factory({
				command = "tex-fmt",
				args = { "--stdin" },
				to_stdin = true,
			}),
		}

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.isort,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.clang_format,
				tex_fmt_custom,
			},
		})
	end,
}
