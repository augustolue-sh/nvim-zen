-- ============================================
-- mini.nvim — Plugins opcionales ultraligeros
-- ============================================

local ok, _ = pcall(require, 'mini')

if not ok then
  -- mini.nvim no está instalado
  vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
      vim.notify(
        'mini.nvim no instalado (opcional). Ejecuta:\n' ..
        'git clone https://github.com/echasnovski/mini.nvim ' ..
        '~/.config/nvim/pack/plugins/start/mini.nvim',
        vim.log.levels.INFO
      )
    end,
    once = true
  })
  return
end

-- Buscador fuzzy
require('mini.pick').setup({ options = { use_cache = true } })
vim.keymap.set('n', '<leader>f', ':Pick files<CR>', { silent = true })
vim.keymap.set('n', '<leader>g', ':Pick grep_live<CR>', { silent = true })
vim.keymap.set('n', '<leader>b', ':Pick buffers<CR>', { silent = true })

-- Surround
require('mini.surround').setup()

-- Comentarios
require('mini.comment').setup()

-- Indent guides
require('mini.indentscope').setup({
  symbol = '│',
  draw = { delay = 0, animation = require('mini.indentscope').gen_animation.none() }
})

-- Diff en gutter
require('mini.diff').setup({
  view = {
    style = 'sign',
    signs = { add = '+', change = '~', delete = '-' }
  }
})

-- Pares automáticos
require('mini.pairs').setup()
