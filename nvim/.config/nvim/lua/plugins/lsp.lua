-- =====================================================================
-- LSP: el cerebro del editor. Autocompletado, diagnósticos, go-to,
-- renombrado, etc. Mason instala los servidores automáticamente.
--
-- Usamos la API NATIVA de Neovim 0.11+ (vim.lsp.config / vim.lsp.enable),
-- que es la forma más moderna y no depende del framework antiguo.
-- =====================================================================

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} }, -- instalador de servidores/tools
    "mason-org/mason-lspconfig.nvim", -- puente Mason <-> lspconfig
    "saghen/blink.cmp", -- para inyectar capabilities de autocompletado
  },
  config = function()
    -- Capabilities que anuncian al servidor lo que blink.cmp soporta.
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    -- Servidores por lenguaje. La tabla vacía {} significa "config por defecto".
    local servers = {
      lua_ls = {}, -- Lua (para editar esta config)
      pyright = {}, -- Python: tipos / análisis
      ruff = {}, -- Python: linting + formateo (rapidísimo)
      ts_ls = {}, -- JavaScript / TypeScript
      yamlls = {}, -- YAML
      marksman = {}, -- Markdown
    }

    require("mason-lspconfig").setup({
      ensure_installed = vim.tbl_keys(servers),
      automatic_enable = false, -- los habilitamos nosotros, abajo (explícito)
    })

    -- Registrar y habilitar cada servidor con la API nativa.
    for name, cfg in pairs(servers) do
      cfg.capabilities = capabilities
      vim.lsp.config(name, cfg)
      vim.lsp.enable(name)
    end

    -- Atajos que solo existen cuando un LSP se "adjunta" a un buffer.
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(ev)
        local function map(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
        end
        map("gd", vim.lsp.buf.definition, "Ir a definición")
        map("gr", vim.lsp.buf.references, "Listar referencias")
        map("K", vim.lsp.buf.hover, "Documentación")
        map("<leader>rn", vim.lsp.buf.rename, "Renombrar símbolo")
        map("<leader>ca", vim.lsp.buf.code_action, "Acción de código")
        map("<leader>cd", vim.diagnostic.open_float, "Ver diagnóstico en línea")
        map("[d", function()
          vim.diagnostic.jump({ count = -1 })
        end, "Diagnóstico anterior")
        map("]d", function()
          vim.diagnostic.jump({ count = 1 })
        end, "Diagnóstico siguiente")
      end,
    })
  end,
}
