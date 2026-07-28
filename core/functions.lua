-- ============================================
-- Funciones auxiliares (F1-F8, auto-pairs, etc.)
-- ============================================

local M = {}

-- ============================================
-- Auto-pairs nativo
-- ============================================

local auto_pairs = {
  ['('] = ')',
  ['['] = ']',
  ['{'] = '}',
  ["'"] = "'",
  ['"'] = '"',
  ['`'] = '`',
}

function M.setup_autopairs()
  for open, close in pairs(auto_pairs) do
    vim.keymap.set('i', open, open .. close .. '<Left>', { silent = true })
  end

  -- Saltar sobre closing bracket
  vim.keymap.set('i', '<C-l>', function()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local next_char = line:sub(col + 1, col + 1)
    if next_char == ')' or next_char == ']' or next_char == '}' or
       next_char == '"' or next_char == "'" or next_char == '`' then
      return '<Right>'
    end
    return '<C-l>'
  end, { silent = true, expr = true })
end

-- ============================================
-- Teclas de función (F1-F8)
-- ============================================

function M.setup_f_keys()
  -- F1: Terminal flotante
  vim.keymap.set('n', '<F1>', function()
    vim.cmd('belowright 15split | terminal')
    vim.cmd('startinsert')
  end, { silent = true })

  -- F2: Toggle números relativos
  vim.keymap.set('n', '<F2>', function()
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
  end, { silent = true })

  -- F3: Toggle wrap
  vim.keymap.set('n', '<F3>', function()
    vim.opt.wrap = not vim.opt.wrap:get()
    print('Wrap: ' .. (vim.opt.wrap:get() and 'ON' or 'OFF'))
  end, { silent = true })

  -- F4: Formato manual
  vim.keymap.set('n', '<F4>', function()
    local save_cursor = vim.fn.getpos('.')
    vim.cmd('silent! normal gg=G')
    vim.fn.setpos('.', save_cursor)
    print('Formateado')
  end, { silent = true })

  -- F5: Ejecutar archivo actual
  vim.keymap.set('n', '<F5>', function()
    local ft = vim.bo.filetype
    local filename = vim.fn.expand('%:p')
    local commands = {
      python = 'python3 ' .. filename,
      lua = 'lua ' .. filename,
      javascript = 'node ' .. filename,
      typescript = 'npx ts-node ' .. filename,
      go = 'go run ' .. filename,
      rust = 'cargo run',
      sh = 'bash ' .. filename,
      zsh = 'zsh ' .. filename,
      c = 'gcc ' .. filename .. ' -o /tmp/a.out && /tmp/a.out',
      cpp = 'g++ ' .. filename .. ' -o /tmp/a.out && /tmp/a.out',
      java = 'javac ' .. filename .. ' && java ' .. vim.fn.expand('%:t:r'),
    }
    local cmd = commands[ft]
    if cmd then
      vim.cmd('belowright 15split | terminal ' .. cmd)
      vim.cmd('startinsert')
    else
      print('No hay comando para: ' .. ft)
    end
  end, { silent = true })

  -- F6: Toggle spell check
  vim.keymap.set('n', '<F6>', function()
    vim.opt.spell = not vim.opt.spell:get()
    print('Spell: ' .. (vim.opt.spell:get() and 'ON' or 'OFF'))
  end, { silent = true })

  -- F7: Diff vs git HEAD
  vim.keymap.set('n', '<F7>', function()
    local current_file = vim.fn.expand('%')
    local tmp_file = '/tmp/git_head_' .. vim.fn.expand('%:t')
    vim.cmd('diffthis')
    vim.cmd('vsplit')
    vim.cmd('silent !git show HEAD:' .. current_file .. ' > ' .. tmp_file)
    vim.cmd('e ' .. tmp_file)
    vim.cmd('diffthis')
  end, { silent = true })

  -- F8: Lista de buffers
  vim.keymap.set('n', '<F8>', ':ls<CR>:b ', { silent = true, noremap = true })
end

-- Inicializar
M.setup_autopairs()
M.setup_f_keys()

return M
