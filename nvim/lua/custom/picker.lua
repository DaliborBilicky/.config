local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
	vim.notify("Telescope not found!", vim.log.levels.ERROR)
	return
end

local themes = require("telescope.themes")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

vim.ui.select = function(items, opts, on_choice)
	opts = opts or {}

	pickers
		.new(
			{},
			themes.get_dropdown({
				prompt_title = opts.prompt or "Select an option",
				finder = finders.new_table({
					results = items,
					entry_maker = function(item)
						return {
							value = item,
							display = opts.format_item and opts.format_item(item) or tostring(item),
							ordinal = tostring(item),
						}
					end,
				}),
				sorter = conf.generic_sorter({}),
				attach_mappings = function(prompt_bufnr, _)
					actions.select_default:replace(function()
						actions.close(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						if selection then
							on_choice(selection.value)
						else
							on_choice(nil)
						end
					end)
					return true
				end,
			})
		)
		:find()
end
