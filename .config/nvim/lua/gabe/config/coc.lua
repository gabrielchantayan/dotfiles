vim.g.coc_global_extensions = { "coc-go" }

local keyset = vim.keymap.set

-- Tab is reserved for Windsurf suggestion accept; navigate the CoC popup with
-- <C-n>/<C-p> (or arrow keys) and confirm with <CR> (mapped below).

-- Use <c-j> to expand/jump in snippets (needs coc-snippets extension)
keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)", { remap = true, silent = true })

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

-- GoTo code navigation
keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
keyset("n", "gr", "<Plug>(coc-references)", { silent = true })

-- Use K to show documentation in preview window
function _G.show_docs()
	local cw = vim.fn.expand("<cword>")
	if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
		vim.api.nvim_command("h " .. cw)
	elseif vim.api.nvim_eval("coc#rpc#ready()") then
		vim.fn.CocActionAsync("doHover")
	else
		vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
	end
end
keyset("n", "K", "<CMD>lua _G.show_docs()<CR>", { silent = true })

-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
	group = "CocGroup",
	command = "silent call CocActionAsync('highlight')",
	desc = "Highlight symbol under cursor on CursorHold",
})

-- Symbol renaming
keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })

local remap = vim.api.nvim_set_keymap
local npairs = require("nvim-autopairs")
npairs.setup({ map_cr = false })

_G.MUtils = {}

local coc_filetypes = {
	go = true,
	javascript = true,
	javascriptreact = true,
	typescript = true,
	typescriptreact = true,
	python = true,
}

MUtils.completion_confirm = function()
	local has_cmp, cmp = pcall(require, "cmp")
	if has_cmp and cmp.visible() then
		cmp.confirm({ select = true })
		return ""
	elseif coc_filetypes[vim.bo.filetype] and vim.fn["coc#pum#visible"]() ~= 0 then
		return vim.fn["coc#pum#confirm"]()
	else
		return npairs.autopairs_cr()
	end
end

remap("i", "<CR>", "v:lua.MUtils.completion_confirm()", { expr = true, noremap = true })
