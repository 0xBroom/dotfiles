-- =====================================================================
-- blink.cmp: motor de autocompletado moderno (núcleo en Rust, muy rápido).
-- Reemplazo de nvim-cmp. Usa un binario precompilado (no requiere cargo).
-- =====================================================================

return {
  "saghen/blink.cmp",
  version = "1.*", -- descarga el binario precompilado de la release
  event = "InsertEnter",
  dependencies = { "rafamadriz/friendly-snippets" }, -- snippets listos para usar
  opts = {
    -- Preset "default": <C-space> abre, <C-y> acepta, <C-n>/<C-p> navega.
    keymap = { preset = "default" },
    appearance = { nerd_font_variant = "mono" },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    completion = {
      documentation = { auto_show = true }, -- muestra docs del candidato
    },
    signature = { enabled = true }, -- ayuda de firma de funciones
  },
}
