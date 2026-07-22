return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	config = function()
		local ensure_installed = {
			"c",
			"cpp",
			"java",
			"markdown",
			"markdown_inline",
			"lua",
			"query",
			"python",
			"vim",
			"vimdoc",
		}

		require("nvim-treesitter").setup()

		require("nvim-treesitter").install(ensure_installed)

		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
