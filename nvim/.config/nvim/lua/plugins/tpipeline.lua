return {
  {
    "vimpostor/vim-tpipeline",
    event = "VeryLazy",
    init = function()
      vim.g.tpipeline_clearstl = 1
    end,
  },
}
