-- =====================================================================
-- Punto de entrada de la configuración de Neovim.
-- Lo mantenemos MÍNIMO a propósito: solo carga los módulos.
-- Toda la lógica vive en lua/config/ y lua/plugins/.
-- =====================================================================

-- El "leader" debe definirse ANTES de cargar lazy.nvim, porque los
-- plugins capturan su valor al registrar sus atajos.
vim.g.mapleader = " " -- la barra espaciadora como tecla líder
vim.g.maplocalleader = "\\"

require("config.options") -- opciones del editor
require("config.keymaps") -- atajos base
require("config.lazy") -- gestor de plugins (lazy.nvim) + plugins
