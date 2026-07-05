-- =====================================================================
-- Tema de colores. NO toques este archivo para cambiar el tema:
-- el flavour se define en lua/config/settings.lua (panel de control).
-- =====================================================================

local settings = require("config.settings")

return {
  "catppuccin/nvim",
  name = "catppuccin", -- el repo se llama "nvim"; lo renombramos para claridad
  lazy = false, -- el tema debe cargar al inicio...
  priority = 1000, -- ...y ANTES que el resto de plugins.
  config = function()
    require("catppuccin").setup({
      flavour = settings.flavour, -- ← viene del panel de control
    })
    vim.cmd.colorscheme(settings.colorscheme)
  end,
}
