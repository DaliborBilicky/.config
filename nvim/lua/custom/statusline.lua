local diag_cache = {}

vim.api.nvim_create_autocmd({ "DiagnosticChanged", "BufEnter" }, {
	callback = function(args)
		local bufnr = args.buf
		local counts = vim.diagnostic.count and vim.diagnostic.count(bufnr) or {}
		local errors = counts[vim.diagnostic.severity.ERROR] or 0
		local warns = counts[vim.diagnostic.severity.WARN] or 0
		local infos = counts[vim.diagnostic.severity.INFO] or 0
		local hints = counts[vim.diagnostic.severity.HINT] or 0

		if errors + warns + infos + hints > 0 then
			diag_cache[bufnr] = string.format(" %d  %d  %d  %d", errors, warns, infos, hints)
		else
			diag_cache[bufnr] = ""
		end
	end,
})

function _G.MyStatusLine()
	local mode_map = {
		n = "N",
		i = "I",
		v = "V",
		["\22"] = "V",
		V = "V",
		c = "C",
		no = "N",
		s = "S",
		S = "S",
		["\19"] = "S",
		ic = "I",
		R = "R",
		Rv = "R",
		t = "T",
	}

	local mode = mode_map[vim.fn.mode()] or "U"
	local filename = vim.fn.expand("%:t")

	local diff = ""
	local gsd = vim.b.gitsigns_status_dict
	if gsd and ((gsd.added or 0) > 0 or (gsd.changed or 0) > 0 or (gsd.removed or 0) > 0) then
		diff = string.format(" %s  %s  %s", gsd.added or 0, gsd.changed or 0, gsd.removed or 0)
	end

	local recording = vim.fn.reg_recording()
	if recording ~= "" then
		recording = string.format("recording @%s", recording)
	end

	local diagnostics = diag_cache[vim.api.nvim_get_current_buf()] or ""

	local line = vim.fn.line(".")
	local total = math.max(vim.fn.line("$"), 1)
	local progress = math.floor((line / total) * 100)
	local location = string.format("%d:%d", line, vim.fn.col("."))

	return string.format(
		"%%#CursorLine# %s %s  %s %s %%= %s  %d%%%% %s ",
		mode,
		filename,
		diff,
		recording,
		diagnostics,
		progress,
		location
	)
end

vim.opt.statusline = "%!v:lua.MyStatusLine()"
