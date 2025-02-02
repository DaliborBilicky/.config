return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/playground",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"c",
				"cpp",
				"markdown",
				"markdown_inline",
				"lua",
				"query",
				"python",
				"vim",
				"vimdoc",
			},
			highlight = { enable = true },
			indent = { enable = true },
			playground = {
				enable = true,
			},
		})
	end,
}
