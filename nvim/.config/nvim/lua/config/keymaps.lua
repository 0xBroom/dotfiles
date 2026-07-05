-- =====================================================================
-- Atajos base (los de plugins viven junto a cada plugin, en sus `keys`).
-- =====================================================================

local map = vim.keymap.set

-- <Esc> limpia el resaltado de búsqueda.
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Limpiar resaltado" })

-- Navegación entre ventanas con Ctrl + h/j/k/l (sin <C-w> previo).
map("n", "<C-h>", "<C-w>h", { desc = "Ir a ventana izquierda" })
map("n", "<C-j>", "<C-w>j", { desc = "Ir a ventana de abajo" })
map("n", "<C-k>", "<C-w>k", { desc = "Ir a ventana de arriba" })
map("n", "<C-l>", "<C-w>l", { desc = "Ir a ventana derecha" })

-- Mover líneas seleccionadas en modo visual (J/K) manteniendo la selección.
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Mover selección abajo" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Mover selección arriba" })

-- Mantener el cursor centrado al hacer scroll de media página y al buscar.
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Guardar rápido.
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Guardar archivo" })

-- Recordatorio: en Neovim 0.10+ el comentado es NATIVO:
--   gcc  -> comenta/descomenta la línea
--   gc   -> en modo visual, comenta la selección
-- No hace falta plugin para eso.
