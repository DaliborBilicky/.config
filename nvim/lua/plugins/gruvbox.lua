return {
	"sainnhe/gruvbox-material",
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.gruvbox_material_enable_italic = 1
		vim.g.gruvbox_material_transparent_background = 2
		vim.g.gruvbox_material_diagnostic_text_highlight = 1
		vim.g.gruvbox_material_foreground = "original"
		vim.g.gruvbox_material_float_style = "blend"
		vim.g.gruvbox_material_ui_contrast = "high"
		vim.cmd.colorscheme("gruvbox-material")
		vim.api.nvim_set_hl(0, "CursorLine", { bg = "#3c3836" })
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ebdbb2", bg = "#3c3836" })
		vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = "#7c6f64" })
		vim.api.nvim_set_hl(0, "TelescopeSelection", { link = "CursorLine" })
	end,
}
