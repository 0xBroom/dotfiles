-- =====================================================================
-- Calidad de vida: descubrir atajos, cerrar pares, guías de indentación.
-- Varios plugins pequeños en un solo archivo (lazy acepta una lista).
-- =====================================================================

return {
  -- which-key: al tipear <leader> (espacio) y esperar, muestra un menú
  -- con los atajos disponibles. Es tu mejor herramienta para APRENDER.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Cierra automáticamente paréntesis, comillas y llaves.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Líneas verticales que marcan los niveles de indentación.
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}
