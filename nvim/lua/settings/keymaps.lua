vim.g.mapleader = " "

local send_to_sqlcl = function()
	vim.cmd('normal! "sy')
	local text = vim.fn.getreg("s")
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buftype == "terminal" then
			local chan = vim.b[buf].terminal_job_id
			if chan then
				vim.api.nvim_chan_send(chan, "CLEAR SCREEN\n")
				vim.api.nvim_chan_send(chan, text .. "\n")
				local win = vim.fn.bufwinid(buf)
				if win ~= -1 then
					local line_count = vim.api.nvim_buf_line_count(buf)
					vim.api.nvim_win_set_cursor(win, { line_count, 0 })
				end
				return
			end
		end
	end
end

vim.keymap.set("v", "<leader>e", send_to_sqlcl)

local toggleSpellLang = function()
	if vim.o.spelllang == "sk" then
		vim.o.spelllang = "en"
		print("Spell checking set to English")
	else
		vim.o.spelllang = "sk"
		print("Spell checking set to Slovak")
	end
end

vim.keymap.set("n", "<leader>ts", toggleSpellLang)

local formatOnSave = function()
	vim.lsp.buf.format()
	vim.cmd("write!")
end

vim.keymap.set("n", "<leader>w", formatOnSave)
vim.keymap.set("n", "<leader>ex", ":Explore<CR><CR>")
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float)
vim.keymap.set("n", "K", vim.lsp.buf.hover)

vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<C-Up>", ":resize -2<CR>")
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")
