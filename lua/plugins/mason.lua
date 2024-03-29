local M = {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
}

function M.config()
  local servers = {
    "lua_ls",
    "pyright",
    "clangd",
  }

  require("mason").setup()
  require("mason-lspconfig").setup({ ensure_installed = servers })
  Set_keymap("n", "<leader>pm", "<cmd>Mason<cr>")
end

return M
