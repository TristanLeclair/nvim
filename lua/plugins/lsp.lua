local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "folke/neodev.nvim",
    },
  },
}

function M.config()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
      -- Enable completion triggered by <c-x><c-o>
      vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

      -- Buffer local mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      local opts = { buffer = ev.buf, silent = true }
      Set_keymap("n", "gD", vim.lsp.buf.declaration, opts, "Declaration")
      -- Set_keymap("n", "gd", vim.lsp.buf.definition, opts, "Definition")
      Set_keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts, "Definition")
      Set_keymap("n", "K", vim.lsp.buf.hover, opts, "Hover")
      -- Set_keymap("n", "gI", vim.lsp.buf.implementation, opts, "Implementation")
      Set_keymap("n", "gI", "<cmd>Telescope lsp_implementations<CR>", opts, "Implementation")
      Set_keymap("i", "<C-h>", vim.lsp.buf.signature_help, opts, "Signature Help")
      Set_keymap("n", "<leader>D", vim.lsp.buf.type_definition, opts, "Type Definition")
      Set_keymap("n", "<leader>lr", vim.lsp.buf.rename, opts, "Rename")
      Set_keymap({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts, "Code Action")

      -- Set_keymap("n", "gr", vim.lsp.buf.references, opts, "References")
      Set_keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", opts, "References")

      Set_keymap("n", "<leader>d", vim.diagnostic.open_float, opts, "Show Line Diagnostics")
      Set_keymap("n", "<leader>lj", vim.diagnostic.goto_next, opts, "Next Diagnostic")
      Set_keymap("n", "<leader>lk", vim.diagnostic.goto_prev, opts, "Prev Diagnostic")

      -- Set_keymap("n", "<leader>lf", function()
      --   vim.lsp.buf.format({ async = true })
      -- end, opts, "Format")

      Set_keymap("n", "<leader>lii", "<cmd>LspInfo<CR>", opts, "Lsp Info")
      Set_keymap("n", "<leader>lir", "<cmd>LspRestart<CR>", opts, "Lsp Restart")
    end,
  })

  local lspconfig = require("lspconfig")

  local servers = {
    "lua_ls",
    "pyright",
    "clangd",
    "html",
    "cssls",
  }

  for _, server in pairs(servers) do
    local opts = {
      -- on_attach = M.on_attach,
    }

    local require_ok, settings = pcall(require, "plugins.handlers." .. server)
    if require_ok then
      opts = vim.tbl_deep_extend("force", settings, opts)
    end

    if server == "lua_ls" then
      require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
      })
    end

    lspconfig[server].setup(opts)
  end
end

return M
