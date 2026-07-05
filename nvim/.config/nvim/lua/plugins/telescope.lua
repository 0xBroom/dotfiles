-- =====================================================================
-- Telescope: el buscador difuso (fuzzy finder). Archivos, texto, buffers...
-- =====================================================================

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- Acelera el filtrado difuso (requiere `make`, que ya tenés).
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  cmd = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Buscar archivos" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Buscar texto (grep)" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buscar buffers abiertos" },
    { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Archivos recientes" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Buscar en la ayuda" },
    { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Listar diagnósticos" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({})
    pcall(telescope.load_extension, "fzf")
  end,
}
