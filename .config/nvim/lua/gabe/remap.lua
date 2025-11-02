local which_key = require("which-key")
local builtin = require("telescope.builtin")

-- Function to jump to buffer by number
local function goto_buffer()
	local num = vim.fn.input("Buffer #: ")
	if tonumber(num) then
		vim.cmd("buffer " .. num)
	else
		print("Invalid buffer number")
	end
end

-- Buffer keymaps
local buffer_mappings = {
	{ "<leader>b", group = "Buffers" },
	{ "<leader>bb", "<cmd>buffers<cr>", desc = "Buffers" },
	{ "<leader>bd", "<cmd>bdelete<cr>", desc = "Delete Buffer" },
	{ "<leader>bn", "<cmd>bnext<cr>", desc = "Next Buffer" },
	{ "<leader>bp", "<cmd>bprevious<cr>", desc = "Previous Buffer" },
	{ "<leader>bj", goto_buffer, desc = "Jump to buffer by number" },
	{ "<leader>bcc", "<cmd>%bw!<cr><cmd>Neotree<cr><C-w>l", desc = "Close all buffers" },
}

which_key.add(buffer_mappings)

-- Telescope keymaps (find files)
local telescope_mappings = {
	{ "<leader>f", group = "Find" },
	{ "<leader>ff", builtin.find_files, desc = "Find files" },
	{ "<leader>fg", builtin.git_files, desc = "Find git files" },
	{ "<leader>fl", builtin.live_grep, desc = "Live grep" },
	{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
	{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find help" },
	{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
}

which_key.add(telescope_mappings)

-- Windowpane mappings
local window_mappings = {
	{ "<leader>w", group = "Windows" },
	{ "<leader>wh", "<C-w>h", desc = "Left Window" },
	{ "<leader>wj", "<C-w>j", desc = "Down Window" },
	{ "<leader>wk", "<C-w>k", desc = "Up Window" },
	{ "<leader>wl", "<C-w>l", desc = "Right Window" },
	{ "<leader>wv", "<C-w>v<C-w>l", desc = "Vertical Split" },
	{ "<leader>ws", "<C-w>s<C-w>j", desc = "Horizontal Split" },
	{ "<leader>wt", "<cmd>Neotree<cr>", desc = "Jump to Neotree" },
	{ "<leader>wq", "<C-w>q", desc = "Close Window" },
}

which_key.add(window_mappings)

local misc_mappings = {
	{ "<leader>ef", "<cmd>Neotree reveal<cr>", desc = "Reveal current file" },
	{ "<leader>ot", "<cmd>terminal<cr>i", desc = "Open terminal" },
	{ "<leader>oc", "<cmd>terminal claude --model claude-haiku-4-5<cr>i", desc = "Open Claude Code" },
}

which_key.add(misc_mappings)

-- Move lines
vim.keymap.set("n", "<A-j>", "<Esc>:m .+1<CR>==gi", { silent = true, remap = true })
vim.keymap.set("n", "<A-k>", "<Esc>:m .-2<CR>==gi", { silent = true, remap = true })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true })

-- Delete without copying
vim.keymap.set("n", "dd", '"_dd')
vim.keymap.set("v", "d", '"_d')

-- Yank remap (+y to y)
vim.keymap.set({ "n", "v" }, "y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "yy", '"+yy', { desc = "Yank line to system clipboard" })
