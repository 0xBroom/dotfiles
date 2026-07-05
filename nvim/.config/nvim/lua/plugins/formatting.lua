-- =====================================================================
-- conform.nvim: formateo de código. Formatea al guardar y con <leader>cf.
-- Mason instala los formateadores (prettier, ruff, stylua) por demanda.
-- =====================================================================

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      desc = "Formatear archivo",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_format" },
      -- stop_after_first: usa prettierd si existe; si no, prettier.
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      json = { "prettierd", "prettier", stop_after_first = true },
      yaml = { "prettierd", "prettier", stop_after_first = true },
      markdown = { "prettierd", "prettier", stop_after_first = true },
    },
    -- Formatea al guardar; si no hay formateador, cae al del LSP.
    format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
  },
}
