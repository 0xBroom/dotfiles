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
    -- Detecta la apariencia del sistema en macOS.
    -- `defaults read -g AppleInterfaceStyle` devuelve "Dark" en modo oscuro
    -- y FALLA (sin salida) en modo claro. Con eso decidimos el background.
    local function detect_system_background()
      local out = vim.fn.system({ "defaults", "read", "-g", "AppleInterfaceStyle" })
      if vim.v.shell_error == 0 and out:lower():find("dark") then
        return "dark"
      end
      return "light"
    end

    require("catppuccin").setup({
      -- Si seguimos al sistema usamos "auto": catppuccin elige el flavour
      -- según vim.o.background, leyendo la tabla `background` de abajo.
      -- Si NO, se respeta el flavour fijo del panel de control.
      flavour = settings.follow_system and "auto" or settings.flavour,
      background = {
        light = settings.flavour_light, -- ← latte por defecto
        dark = settings.flavour_dark,
      },
    })

    -- Fija el background ANTES de cargar el tema, así arranca correcto.
    if settings.follow_system then
      vim.o.background = detect_system_background()
    end

    vim.cmd.colorscheme(settings.colorscheme)

    -- Re-chequea al volver el foco a Neovim: si cambiaste la apariencia
    -- de macOS mientras tanto, el tema se adapta al reenfocar la ventana.
    if settings.follow_system then
      vim.api.nvim_create_autocmd("FocusGained", {
        desc = "Sincronizar tema con la apariencia del sistema (macOS)",
        callback = function()
          local prev = vim.o.background
          vim.o.background = detect_system_background()
          if vim.o.background ~= prev then
            vim.cmd.colorscheme(settings.colorscheme)
          end
        end,
      })
    end
  end,
}
