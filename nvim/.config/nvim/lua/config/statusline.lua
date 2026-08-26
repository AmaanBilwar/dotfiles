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

local function mode_name()
  local mode = vim.api.nvim_get_mode().mode
  local key = mode:sub(1, 1)
  return mode_names[key] or mode:upper()
end

local function current_directory()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
end

vim.opt.laststatus = 0

require("lualine").setup({
  options = {
    section_separators = "",
    component_separators = "",
  },
  sections = {},
  inactive_sections = {},
  winbar = {
    lualine_a = { mode_name },
    lualine_b = {
      {
        "filename",
        path = 1,
        cond = function()
          return vim.bo.filetype ~= "oil"
        end,
      },
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { current_directory },
  },
  inactive_winbar = {
    lualine_a = { mode_name },
    lualine_b = {
      {
        "filename",
        path = 1,
        cond = function()
          return vim.bo.filetype ~= "oil"
        end,
      },
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { current_directory },
  },
})
