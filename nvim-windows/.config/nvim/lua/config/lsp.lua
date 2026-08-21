local function on_attach(_, buffer)
  local options = { noremap = true, silent = true, buffer = buffer }

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, options)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, options)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, options)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, options)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, options)
end

vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json", ".git" },
  on_attach = on_attach,
})

vim.lsp.config("ts_ls", {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  on_attach = on_attach,
})

vim.lsp.enable({ "rust_analyzer", "ts_ls" })
