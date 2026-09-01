vim.g.mapleader = " "

vim.keymap.set("n", "<leader>e", "<cmd>Neotree filesystem toggle<cr>", { desc = "Toggle file tree" })
vim.keymap.set("n", "<leader>cd", "<cmd>Neotree filesystem toggle<cr>", { desc = "Toggle file tree" })

vim.keymap.set("n", "<leader>a", function()
	require("harpoon"):list():add()
end, { desc = "Harpoon add file" })
vim.keymap.set("n", "<leader>h", function()
	local harpoon = require("harpoon")
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon menu" })
for index = 1, 4 do
	vim.keymap.set("n", "<leader>" .. index, function()
		require("harpoon"):list():select(index)
	end, { desc = "Harpoon select file " .. index })
end

-- jj exits insert mode...
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Exit terminal input mode without closing terminal buffer.
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "jj", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("x", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { silent = true })
vim.keymap.set("x", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { silent = true })
vim.keymap.set("x", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { silent = true })
vim.keymap.set("x", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { silent = true })

-- Leader bindings (mirrors Zed keymap)
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })

-- refresh quicker in vim
vim.keymap.set("n", "<leader>r", "<cmd>e!<cr>", { desc = "Reload file" })

vim.keymap.set("n", "<leader>ff", function()
	require("fff").find_files()
end, { desc = "FFF find files" })
vim.keymap.set("n", "<leader>fg", function()
	require("fff").live_grep()
end, { desc = "FFF live grep" })
vim.keymap.set("n", "<leader>fr", function()
	require("fff").resume()
end, { desc = "FFF resume last picker" })
vim.keymap.set("n", "-", function()
	local directory = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
	if directory == "" then
		directory = vim.fn.getcwd()
	end
	require("fff").find_files_in_dir(directory)
end, { desc = "FFF find in current directory" })
vim.keymap.set("n", "<leader>gs", function()
	require("fff").live_grep_under_cursor()
end, { desc = "FFF grep word" })
vim.keymap.set("x", "<leader>gs", function()
	require("fff").live_grep_under_cursor()
end, { desc = "FFF grep selection" })
