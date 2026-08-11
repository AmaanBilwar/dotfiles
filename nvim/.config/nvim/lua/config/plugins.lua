local function packadd(package)
  vim.cmd.packadd(package)
end

packadd("fff.nvim")
packadd("oil.nvim")
packadd("mini.nvim")
packadd("nvim-treesitter")

require("oil").setup({
  default_file_explorer = true,
})

require("mini.surround").setup()

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("open_oil_on_empty_start", { clear = true }),
  callback = function()
    if #vim.api.nvim_list_uis() == 0 or vim.fn.argc() ~= 0 or vim.api.nvim_buf_get_name(0) ~= "" then
      return
    end

    vim.cmd.Oil()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true }),
  pattern = { "javascript", "javascriptreact", "lua", "rust", "typescript", "typescriptreact" },
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPre" }, {
  group = vim.api.nvim_create_augroup("load_gitsigns", { clear = true }),
  once = true,
  callback = function()
    packadd("gitsigns.nvim")
    require("gitsigns").setup({
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "^" },
        changedelete = { text = "~" },
        untracked = { text = "+" },
      },
    })
  end,
})
