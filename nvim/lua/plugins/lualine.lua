local function show_recording()
	local recording_register = vim.fn.reg_recording()
	if recording_register == "" then
		return ""
	else
		return "recording @" .. recording_register
	end
end

local colors = {
	black = "#282828",
	white = "#ebdbb2",
	red = "#fb4934",
	green = "#b8bb26",
	blue = "#83a598",
	orange = "#fe8019",
	gray = "#504945",
	lightgray = "#a89984",
	darkgray = "#3c3836",
	inactivegray = "#7c6f64",
}

local gruv = {
	normal = {
		a = { bg = colors.darkgray, fg = colors.white, gui = "bold" },
		b = { bg = colors.darkgray, fg = colors.white },
		c = { bg = colors.darkgray, fg = colors.lightgray },
	},
	insert = {
		a = { bg = colors.darkgray, fg = colors.blue, gui = "bold" },
		b = { bg = colors.darkgray, fg = colors.white },
		c = { bg = colors.darkgray, fg = colors.lightgray },
	},
	visual = {
		a = { bg = colors.darkgray, fg = colors.orange, gui = "bold" },
		b = { bg = colors.darkgray, fg = colors.white },
		c = { bg = colors.darkgray, fg = colors.lightgray },
	},
	replace = {
		a = { bg = colors.darkgray, fg = colors.red, gui = "bold" },
		b = { bg = colors.darkgray, fg = colors.white },
		c = { bg = colors.darkgray, fg = colors.lightgray },
	},
	command = {
		a = { bg = colors.darkgray, fg = colors.green, gui = "bold" },
		b = { bg = colors.darkgray, fg = colors.white },
		c = { bg = colors.darkgray, fg = colors.lightgray },
	},
	inactive = {
		a = { bg = colors.darkgray, fg = colors.lightgray, gui = "bold" },
		b = { bg = colors.darkgray, fg = colors.lightgray },
		c = { bg = colors.darkgray, fg = colors.inactivegray },
	},
}
return {
	"nvim-lualine/lualine.nvim",
	config = function()
		require("lualine").setup({
			options = {
				theme = gruv,
				component_separators = "",
				section_separators = { left = "", right = "" },
				symbols = { error = " ", warn = " ", hint = " ", info = " " },
			},
			sections = {
				lualine_b = { "filename" },
				lualine_c = {
					{
						"macro-recording",
						color = { fg = "#fabd2f" },
						fmt = show_recording,
					},
					"branch",
					"diff",
					"diagnostics",
				},
			},
		})
	end,
}
