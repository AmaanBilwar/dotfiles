local mode_names = {
  n = "NORMAL",
  i = "INSERT",
  v = "VISUAL",
  V = "V-LINE",
  ["\22"] = "V-BLOCK",
  R = "REPLACE",
  c = "COMMAND",
  t = "TERMINAL",
}

local function statusline()
  local mode = vim.api.nvim_get_mode().mode
  local key = mode:sub(1, 1)
  local group = key == "i" and "StatusLineInsert" or "StatusLineNormal"
  local label = mode_names[key] or mode:upper()

  return string.format("%%#%s# %s %%#StatusLine# %%f ", group, label)
end

_G.nvim_statusline = statusline

vim.api.nvim_set_hl(0, "StatusLineNormal", { fg = "#FFFEDB", bg = "#34383C", bold = true })
vim.api.nvim_set_hl(0, "StatusLineInsert", { fg = "#202020", bg = "#00FF00", bold = true })
vim.o.statusline = "%!v:lua.nvim_statusline()"

vim.api.nvim_create_autocmd("ModeChanged", {
  group = vim.api.nvim_create_augroup("statusline_mode", { clear = true }),
  callback = function()
    vim.cmd.redrawstatus()
  end,
})
