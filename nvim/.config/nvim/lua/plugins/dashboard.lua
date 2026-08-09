local function button(key, label, action)
	local dashboard = require("alpha.themes.dashboard")
	local pad = string.rep(" ", math.max(0, 36 - #label))
	return dashboard.button(key, "λ  > " .. label .. pad .. key, action)
end

local header = {
	"                         .. ...:---===+==-: .",
	"                         ..-=+*#%%%@@@%%#*+-....",
	"                        .=+#%@@@@@@@@@@@@@%+-.:  ..",
	"                        :=*#%@@@@@@@@@@@@@@#*+=::.....",
	"                        .-=*%@@@%=.......=%@@@%#*+-:...",
	"                       ..:=*#%*. ..      . =@@@@@#*+-:",
	"                      ...=+*%#..          . @@@@@%#+-..",
	"                    ..:.+*#@@%..           .*@@@@@#+:..",
	"                    ..-+%@@@@+             ..*@@@@#+=: .",
	"                    .:-*@@@@@              ..*@@@@@%+:. .",
	"                  ..:-+#@@@@@#.            .-@@@@@@%%*-",
	"                 . :+#%@@@@@=.             .-@@@@@@@@#=:..",
	"                ..-+#@@@@@:  .              ...-@@@@@%*-...",
	"              ...:=#@@@@*                      ..@@@@@%+-.",
	"           ....:-+#@@@+ .. ....                  -@@@@%#=:",
	"          ...--+#@@@%. .    .+.                 . @@@@@#+:",
	"         ..:=##@@@@% ..    .%@-.                 .:@@@%*=: .",
	"         ..:=*%@@@@@-..    .....                 . *@@@#+-. ..",
	"          ..:=+#@@@@@@.                      .... .:@@@@@#=-. .",
	"           . :-=*%@@@@.                     .=@.   .#@@@@%*+=..",
	"            . .:+%@@@@..                    .@@@.  ..@@@@@%#=.",
	"              .=*#@@@@=                      @@*.    @@@@@*=-...",
	"             ...=*%@@@@..                   .:@:.  .:@@@@@%*=-....",
	"              ...-+#@@@@..                   ....  .%@@@@@@@#*-:...",
	"               ...-+#@@@%..                         ..*@@@@@@%%*+-..",
	"                . :-+%@@@* .                          .. +@@@@@@#+..",
	"                 ..-*#@@@@=.                            ....%@@@#=.",
	"                ...=+#@@@@@..  .. .  ..                     .-@@#+..",
	"             ..  +@@@@@@@@@..  .-+......                    . ###*-.",
	"             .:@@@@@@@@@@@+.    .@@@@@..     . . . .... . ...%@%+-..",
	"              #@@@@@@@@@@+..  ...*@@@.. .. .:+%@@@@@@@@@@@@@@@=.  .",
	"              . +@@@@@@=....  .=%@@@@:....@@@@@@@@@@%##*+-... ..",
	"                 ...+%@#.. .-#@@@@@@@@+.:@@@*=..... . . . .",
	"                  .. .. ..  ....:::::. ........",
	"                             .  .... ..",
}

return {
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		priority = 1001,
		opts = function()
			local dashboard = require("alpha.themes.dashboard")

			return {
				layout = {
					{ type = "padding", val = 2 },
					{ type = "text", val = header, opts = { hl = "AlphaHeader", position = "center" } },
					{ type = "padding", val = 2 },
				},
			}
		end,
		config = function(_, opts)
			require("alpha").setup(opts)

			local function set_alpha_hl()
				local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
				vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#928374", bg = normal.bg })
				vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#ebdbb2", bg = normal.bg })
				vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#665c54", bg = normal.bg })
			end

			set_alpha_hl()
			vim.api.nvim_create_autocmd("ColorScheme", { callback = set_alpha_hl })

			vim.api.nvim_create_autocmd("User", {
				pattern = "AlphaReady",
				callback = function()
					vim.opt_local.number = false
					vim.opt_local.relativenumber = false
					vim.opt_local.cursorline = false
				end,
			})
		end,
	},
}
