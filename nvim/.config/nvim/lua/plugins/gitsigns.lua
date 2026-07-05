-- =====================================================================
-- gitsigns: muestra en el margen qué líneas agregaste / cambiaste /
-- borraste respecto a git, y permite navegar y operar sobre esos cambios.
-- =====================================================================

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(buffer)
      local gs = require("gitsigns")
      local function map(keys, fn, desc)
        vim.keymap.set("n", keys, fn, { buffer = buffer, desc = "Git: " .. desc })
      end
      map("]h", gs.next_hunk, "Siguiente cambio")
      map("[h", gs.prev_hunk, "Cambio anterior")
      map("<leader>gp", gs.preview_hunk, "Previsualizar cambio")
      map("<leader>gb", gs.blame_line, "Blame de la línea")
    end,
  },
}
