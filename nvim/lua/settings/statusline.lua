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
	if vim.b.gitsigns_status_dict then
		local gsd = vim.b.gitsigns_status_dict
		if (gsd.added or 0) > 0 or (gsd.changed or 0) > 0 or (gsd.removed or 0) > 0 then
			diff = string.format(" %s  %s  %s", gsd.added or 0, gsd.changed or 0, gsd.removed or 0)
		end
	end

	local recording = vim.fn.reg_recording()
	if recording == "" then
		recording = ""
	else
		recording = string.format("recording @%s", recording)
	end

	local function count_diag(severity)
		return #vim.diagnostic.get(0, { severity = severity })
	end
	local errors = count_diag(vim.diagnostic.severity.ERROR)
	local warns = count_diag(vim.diagnostic.severity.WARN)
	local infos = count_diag(vim.diagnostic.severity.INFO)
	local hints = count_diag(vim.diagnostic.severity.HINT)
	local diagnostics = ""
	if errors + warns + infos + hints > 0 then
		diagnostics = string.format(" %d  %d  %d  %d", errors, warns, infos, hints)
	end

	local line = vim.fn.line(".")
	local total = vim.fn.line("$")
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
