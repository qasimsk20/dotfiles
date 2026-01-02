return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "n",
				desc = "Format file",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				cpp = { "clang_format" },
				cmake = { "cmakelang" },
				c = { "clang_format" },
				java = { "google_java_format" },
				-- Other filetypes will use auto-discovery
			},
		},
	},
}

