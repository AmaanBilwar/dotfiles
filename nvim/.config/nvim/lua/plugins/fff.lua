return {
	"dmtrKovalenko/fff.nvim",
	lazy = false,
	keys = {
		{
			"<leader>ff",
			function()
				require("fff").find_files()
			end,
			desc = "FFF find files",
		},
		{
			"<leader>fg",
			function()
				require("fff").live_grep()
			end,
			desc = "FFF live grep",
		},
		{
			"<leader>fr",
			function()
				require("fff").resume()
			end,
			desc = "FFF resume last picker",
		},
		{
			"-",
			function()
				local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
				if dir == "" then
					dir = vim.fn.getcwd()
				end
				require("fff").find_files_in_dir(dir)
			end,
			desc = "FFF find in current directory",
		},
		{
			"<leader>gs",
			function()
				require("fff").live_grep_under_cursor()
			end,
			mode = { "n", "x" },
			desc = "FFF grep word/selection",
		},
	},
}
