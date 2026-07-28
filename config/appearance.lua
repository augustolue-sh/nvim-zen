-- ============================================
-- Apariencia — Colores Apple + Barra de estado
-- ============================================

-- Colores base
vim.cmd [[
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NonText guibg=NONE
  highlight LineNr guifg=#8E8E93 ctermfg=245 guibg=NONE
  highlight CursorLineNr guifg=#FFFFFF guibg=NONE
  highlight CursorLine guibg=#2C2C2E guifg=NONE
  highlight Visual guibg=#3A3A3C guifg=NONE
  highlight Search guibg=#4A4A4C guifg=#FFFFFF
  highlight Pmenu guibg=#2C2C2E guifg=#FFFFFF
  highlight PmenuSel guibg=#3A3A3C guifg=#FFFFFF
  highlight StatusLine guibg=#1C1C1E guifg=#8E8E93
  highlight StatusLineNC guibg=#1C1C1E guifg=#4A4A4C
  highlight TabLine guibg=#1C1C1E guifg=#8E8E93
  highlight TabLineSel guibg=#3A3A3C guifg=#FFFFFF
  highlight TabLineFill guibg=#1C1C1E
  highlight Title guifg=#FFFFFF guibg=NONE
  highlight Comment guifg=#6C6C70 guibg=NONE
  highlight Constant guifg=#FF9F0A
  highlight String guifg=#FF375F
  highlight Function guifg=#64D2FF
  highlight Keyword guifg=#FF6B6B
  highlight Type guifg=#34C759
  highlight Identifier guifg=#A2845E
]]

-- Diagnostics
vim.cmd [[
  highlight DiagnosticError guifg=#FF453A guibg=NONE
  highlight DiagnosticWarn  guifg=#FF9F0A guibg=NONE
  highlight DiagnosticInfo  guifg=#64D2FF guibg=NONE
  highlight DiagnosticHint  guifg=#34C759 guibg=NONE
  highlight DiagnosticUnderlineError gui=underline guisp=#FF453A
  highlight DiagnosticUnderlineWarn  gui=underline guisp=#FF9F0A
  highlight DiagnosticSignError guifg=#FF453A guibg=NONE
  highlight DiagnosticSignWarn  guifg=#FF9F0A guibg=NONE
  highlight DiagnosticSignInfo  guifg=#64D2FF guibg=NONE
  highlight DiagnosticSignHint  guifg=#34C759 guibg=NONE
]]

-- ============================================
-- Barra de estado inteligente
-- ============================================

local M = {}

M.mode_colors = {
  n = '#64D2FF',
  i = '#34C759',
  v = '#FF375F',
  V = '#FF375F',
  ['\22'] = '#FF375F',
  c = '#FF9F0A',
  r = '#FF6B6B',
  t = '#A2845E',
}

M.mode_labels = {
  n = 'NORMAL',
  i = 'INSERT',
  v = 'VISUAL',
  V = 'V-LINE',
  ['\22'] = 'V-BLOCK',
  c = 'COMMAND',
  r = 'REPLACE',
  t = 'TERMINAL',
}

function M.get_git_branch()
  local handle = io.popen('git branch --show-current 2>/dev/null')
  if not handle then return '' end
  local branch = handle:read('*a'):gsub('%s+$', '')
  handle:close()
  return branch
end

function M.get_diagnostics()
  local error_count = 0
  local warn_count = 0
  if vim.diagnostic then
    local counts = vim.diagnostic.count(0)
    if counts then
      error_count = counts[1] or 0
      warn_count = counts[2] or 0
    end
  end
  local parts = {}
  if error_count > 0 then table.insert(parts, 'E:' .. error_count) end
  if warn_count > 0 then table.insert(parts, 'W:' .. warn_count) end
  return table.concat(parts, ' ')
end

function _G.statusline()
  local mode = vim.fn.mode()
  local mode_color = M.mode_colors[mode] or '#8E8E93'
  local mode_label = M.mode_labels[mode] or mode:upper()

  local filename = vim.fn.expand('%:t')
  if filename == '' then filename = '[Sin nombre]' end
  local modified = vim.bo.modified and ' [+]' or ''
  local readonly = vim.bo.readonly and ' [RO]' or ''

  local filetype = vim.bo.filetype
  if filetype == '' then filetype = 'text' end

  local encoding = vim.bo.fileencoding
  if encoding == '' then encoding = vim.o.encoding end

  local indent = vim.bo.expandtab and (vim.bo.shiftwidth .. 'sp') or (vim.bo.tabstop .. 't')

  local branch = M.get_git_branch()
  local diagnostics = M.get_diagnostics()

  local line = vim.fn.line('.')
  local col = vim.fn.col('.')
  local total = vim.fn.line('$')
  local percent = math.floor((line / total) * 100)

  -- Construir string
  local left = ' ' .. mode_label .. ' ' .. filename .. modified .. readonly .. ' '
  local center = ' ' .. filetype .. ' | ' .. encoding:upper() .. ' | ' .. indent .. ' '
  local right = ''

  if branch ~= '' then
    right = right .. ' ' .. branch .. ' '
  end
  if diagnostics ~= '' then
    if right ~= '' then right = right .. '|' end
    right = right .. ' ' .. diagnostics .. ' '
  end
  if right ~= '' then right = right .. '|' end
  right = right .. ' ' .. line .. ':' .. col .. ' ' .. percent .. '% '

  -- Actualizar color del modo
  vim.cmd('highlight StatusLineMode guibg=' .. mode_color .. ' guifg=#1C1C1E gui=bold')

  return '%#StatusLineMode#' .. left .. '%#StatusLine#' .. '%=' .. center .. '%=' .. right
end

vim.o.statusline = '%!v:lua.statusline()'

return M
