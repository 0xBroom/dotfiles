-- =====================================================================
-- lualine: barra de estado. Muestra modo, archivo, git, diagnósticos
-- y la POSICIÓN (línea:columna y % del archivo) abajo a la derecha.
-- =====================================================================

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    options = {
      theme = "auto", -- deriva los colores del colorscheme activo (catppuccin)
      globalstatus = true, -- una sola barra para todas las ventanas
      section_separators = "",
      component_separators = "",
    },
    sections = {
      lualine_z = {
        "progress", -- porcentaje de avance dentro del archivo
        "location", -- línea:columna exactas
      },
    },
  },
}
