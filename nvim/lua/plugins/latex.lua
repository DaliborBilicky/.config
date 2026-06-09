return {
	"lervag/vimtex",
	lazy = false,
	init = function()
		vim.g.vimtex_view_method = "zathura"
		vim.g.vimtex_view_automatic = 1
		vim.g.vimtex_compiler_method = "latexmk"
	end,
}
