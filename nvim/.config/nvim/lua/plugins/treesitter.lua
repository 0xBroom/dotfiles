-- =====================================================================
-- Treesitter: resaltado de sintaxis REAL (basado en árbol sintáctico,
-- no en expresiones regulares). Base para resaltado, indentación e
-- inyecciones (p. ej. el YAML dentro del frontmatter de un .md).
--
-- IMPORTANTE — rama `main` (no `master`):
--   La rama `master` está CONGELADA y NO soporta Neovim 0.12.
--   `main` es el rewrite mantenido y requiere Neovim 0.12+.
--   Su API es distinta:
--     · parsers        → require("nvim-treesitter").install({...})
--     · highlight/indent → se encienden por buffer con un autocmd
--                          FileType que llama a vim.treesitter.start().
--   Además `main` NO soporta lazy-loading: por eso lazy=false y sin `event`.
-- =====================================================================

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main", -- rama mantenida, compatible con Neovim 0.12+
  lazy = false, -- main no soporta carga diferida
  build = ":TSUpdate", -- compila/actualiza los parsers instalados
  config = function()
    -- Instala (o deja listos) los parsers de estos lenguajes.
    -- Es asíncrono: la primera vez puede tardar unos segundos.
    require("nvim-treesitter").install({
      "markdown",
      "markdown_inline",
      "yaml",
      "javascript",
      "typescript",
      "tsx",
      "python",
      "lua", -- para editar esta misma config
      "vim",
      "vimdoc",
      "json",
      "html",
      "css",
      "bash",
    })

    -- Enciende treesitter por buffer según su filetype.
    -- En la API `main` esto ya no es un módulo: se hace a mano.
    vim.api.nvim_create_autocmd("FileType", {
      desc = "Treesitter: resaltado + indentación por buffer",
      callback = function(ev)
        local buf = ev.buf
        local ft = vim.bo[buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)
        -- start() arranca resaltado e inyecciones; si el parser aún no
        -- está instalado, pcall evita el error y reintenta al reabrir.
        if lang and pcall(vim.treesitter.start, buf, lang) then
          -- Indentación basada en el árbol (experimental en `main`).
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    -- Aplica también al buffer ya abierto (p. ej. el archivo pasado por CLI),
    -- porque su evento FileType pudo dispararse antes de registrar el autocmd.
    pcall(vim.cmd, "silent! doautocmd FileType")
  end,
}
