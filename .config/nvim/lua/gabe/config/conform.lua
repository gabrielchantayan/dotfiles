require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },
		-- You can customize some of the format options for the filetype (:help conform.format)
		go = { "goimports", "gofmt" },
		rust = { "rustfmt", lsp_format = "fallback" },
		css = { "css_beautify" },
		-- Conform will run the first available formatter
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier" },
		typescriptreact = { "prettierd", "prettier", "rustywind" },
	},
	format_on_save = {
		-- I recommend these options. See :help conform.format for details.
		lsp_format = "fallback",
		timeout_ms = 500,
	},
})
