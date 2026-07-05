-- =====================================================================
-- Opciones del editor (vim.opt). Esto es Neovim "puro", sin plugins.
-- =====================================================================

local opt = vim.opt

-- Números de línea: HÍBRIDO.
--   number       -> muestra el número absoluto en la línea del cursor
--   relativenumber -> muestra distancias relativas en el resto
-- Combinados, sabés en qué línea estás Y cuántas saltar (ej: 8j, 12k).
opt.number = true
opt.relativenumber = true

-- Contexto visual del cursor.
opt.cursorline = true -- resalta la línea actual
opt.scrolloff = 8 -- mantiene 8 líneas de margen al hacer scroll
opt.sidescrolloff = 8

-- Indentación: 2 espacios por defecto (sensato para JS/TS/YAML/MD).
opt.expandtab = true -- tabs -> espacios
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

-- Búsqueda inteligente.
opt.ignorecase = true -- ignora mayúsculas...
opt.smartcase = true -- ...salvo que escribas alguna mayúscula
opt.incsearch = true -- resalta mientras escribís
opt.hlsearch = true -- mantiene el resaltado (lo limpiamos con <Esc>)

-- UI.
opt.termguicolors = true -- colores de 24 bits (necesario para los temas)
opt.signcolumn = "yes" -- columna fija para signos (git/diagnósticos)
opt.wrap = false -- no parte las líneas largas
opt.splitright = true -- splits verticales abren a la derecha
opt.splitbelow = true -- splits horizontales abren abajo

-- Historial y archivos.
opt.swapfile = false
opt.backup = false
opt.undofile = true -- deshacer PERSISTE entre sesiones
opt.updatetime = 250 -- respuesta más ágil (diagnósticos, etc.)

opt.clipboard = "unnamedplus" -- usa el portapapeles del sistema
opt.mouse = "a" -- mouse habilitado en todos los modos

opt.completeopt = "menu,menuone,noselect"
