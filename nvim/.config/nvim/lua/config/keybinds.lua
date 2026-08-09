vim.g.mapleader = " "

vim.keymap.set("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Open Oil" })
vim.keymap.set("n", "<leader>cd", "<cmd>Oil<cr>", { desc = "Open Oil" })
vim.keymap.set("n", "<S-h>", function()
	require("oil").toggle_hidden()
end, { desc = "Oil: toggle hidden files" })

-- jj exits insert mode...
-- UPDATE: now changed to kj...
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Leader bindings (mirrors Zed keymap)
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })

-- refresh quicker in vim
vim.keymap.set("n", "<leader>r", "<cmd>e!<cr>", { desc = "Reload file" })
