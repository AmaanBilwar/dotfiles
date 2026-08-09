return {
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   priority = 1000,
  --   opts = {
  --     -- background = "dark", -- "dark" or "light"
  --     -- contrast = "hard", -- "hard", "soft", or ""
  --   },
  --   config = function()
  --     vim.cmd.colorscheme("gruvbox")
  --   end,
  -- },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- theme = "gruvbox",
      theme = "auto",
    },
  },
}
