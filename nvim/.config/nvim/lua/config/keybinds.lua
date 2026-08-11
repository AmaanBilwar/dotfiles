vim.g.mapleader = " "

vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Open Oil" })
vim.keymap.set("n", "<leader>cd", "<cmd>Oil<cr>", { desc = "Open Oil" })
vim.keymap.set("n", "<S-h>", function()
	require("oil").toggle_hidden()
end, { desc = "Oil: toggle hidden files" })

-- jj exits insert mode...
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

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
