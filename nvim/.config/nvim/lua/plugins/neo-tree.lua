-- =====================================================================
-- neo-tree: el árbol/explorador de archivos lateral.
-- =====================================================================

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- íconos (requiere Nerd Font)
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Explorador de archivos" },
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true, -- cierra Neovim si solo queda el árbol
      filesystem = {
        follow_current_file = { enabled = true }, -- sigue al archivo abierto
        use_libuv_file_watcher = true, -- refresca solo ante cambios en disco
        filtered_items = {
          hide_dotfiles = false, -- mostrar archivos ocultos (.env, etc.)
          hide_gitignored = false,
        },
      },
    })
  end,
}
