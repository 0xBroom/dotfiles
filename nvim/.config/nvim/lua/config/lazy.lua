-- =====================================================================
-- Bootstrap de lazy.nvim (el gestor de plugins moderno).
-- Si no está instalado, lo clona automáticamente la primera vez.
-- =====================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Error al clonar lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nRevisá tu conexión y reiniciá Neovim.", "" },
    }, true, {})
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Carga TODOS los archivos de lua/plugins/ como especificaciones de plugins.
-- Cada archivo devuelve una tabla (o lista de tablas) que lazy entiende.
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  install = { colorscheme = { require("config.settings").colorscheme } },
  checker = { enabled = true, notify = false }, -- avisa de updates sin molestar
  change_detection = { notify = false },
})
