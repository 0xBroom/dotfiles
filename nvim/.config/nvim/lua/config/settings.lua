-- =====================================================================
-- PANEL DE CONTROL — tus preferencias en UN SOLO LUGAR.
-- Cambiá un valor acá y el resto de la config se adapta sola.
-- Esto es "single source of truth": el dato vive una sola vez.
-- =====================================================================

local M = {}

-- Tema de colores.
--   colorscheme: nombre del plugin/tema a aplicar.
--   flavour: variante de catppuccin. SOLO se usa si follow_system = false.
--            Opciones: "latte" (claro) | "frappe" | "macchiato" | "mocha"
M.colorscheme = "catppuccin"
M.flavour = "mocha"

-- Tema claro/oscuro según la apariencia del sistema (macOS).
--   follow_system: si es true, nvim mira el tema de tu Mac
--                  (Ajustes → Apariencia) y elige el flavour solo.
--                  Con esto, M.flavour se ignora.
--   flavour_light: variante para modo CLARO del sistema.
--   flavour_dark:  variante para modo OSCURO del sistema.
M.follow_system = true
M.flavour_light = "latte"
M.flavour_dark = "mocha"

return M
