return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/playground",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"html",
				"css",
				"vimdoc",
				"query",
				"vim",
				"c",
				"cpp",
				"python",
				"java",
				"c_sharp",
				"lua",
				"markdown",
				"markdown_inline",
			},
			highlight = { enable = true },
			indent = { enable = true },
			playground = {
				enable = true,
			},
		})
	end,
}
