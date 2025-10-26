local M = {}

function M:setup()
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

	local os_name = vim.loop.os_uname().sysname
	local os_config = os_name == "Linux" and "linux"
		or os_name == "Darwin" and "mac"
		or os_name == "Windows_NT" and "win"
		or error("Unsupported OS: " .. os_name)

	local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
	local launcher_jar = mason_path .. "/plugins/org.eclipse.equinox.launcher_1.7.0.v20250519-0528.jar"
	local config_dir = mason_path .. "/config_" .. os_config
	local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

	vim.fn.mkdir(workspace_dir, "p")

	if vim.fn.filereadable(launcher_jar) == 0 then
		vim.notify("JDT LS launcher JAR not found: " .. launcher_jar, vim.log.levels.ERROR)
		return
	end

	local config = {
		cmd = {
			"java",
			"-Declipse.application=org.eclipse.jdt.ls.core.id1",
			"-Dosgi.bundles.defaultStartLevel=4",
			"-Declipse.product=org.eclipse.jdt.ls.core.product",
			"-Dlog.protocol=true",
			"-Dlog.level=ALL",
			"-Xmx1g",
			"-jar",
			launcher_jar,
			"-configuration",
			config_dir,
			"-data",
			workspace_dir,
		},
		root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
		settings = {
			java = {},
		},
		init_options = {
			bundles = {},
		},
	}

	require("jdtls").start_or_attach(config)
end

return M
