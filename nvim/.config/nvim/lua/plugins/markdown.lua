-- =====================================================================
-- Markdown "bonito" DENTRO del buffer (no en un navegador aparte).
-- Dibuja headings, bloques de código, listas, tablas y checkboxes
-- usando el árbol de treesitter que ya tenemos (markdown + yaml).
--
-- Sobre el frontmatter YAML de las skills (bloque --- ... ---):
-- treesitter lo reconoce como metadata e inyecta el parser `yaml`,
-- así que la cabecera queda coloreada como YAML real. Este plugin
-- la respeta y no la esconde.
-- =====================================================================

return {
  "MeanderingProgrammer/render-markdown.nvim",
  -- Solo carga al abrir un markdown: no pesa en el arranque.
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- parsers markdown/markdown_inline/yaml
    "nvim-tree/nvim-web-devicons", -- íconos para lenguajes en code blocks
  },
  opts = {
    -- Muestra el render en modos normal/comando; al entrar en INSERT
    -- sobre una línea, la "des-renderiza" para que edites el texto crudo.
    render_modes = { "n", "c", "t" },

    -- Anti-conceal: revela el markdown crudo SOLO en la línea del cursor.
    anti_conceal = { enabled = true },

    heading = {
      -- Íconos por nivel de heading (H1..H6).
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },

    code = {
      -- Muestra el nombre + ícono del lenguaje arriba del bloque
      -- y le da fondo para separarlo visualmente del texto.
      style = "full",
      position = "left",
      width = "block",
    },

    checkbox = {
      unchecked = { icon = "󰄱 " },
      checked = { icon = "󰱒 " },
    },
  },
  -- Convención de esta config: el atajo del plugin vive junto al plugin.
  keys = {
    {
      "<leader>m",
      "<cmd>RenderMarkdown toggle<CR>",
      ft = "markdown",
      desc = "Markdown: alternar render bonito",
    },
  },
}
