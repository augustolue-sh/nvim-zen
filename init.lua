-- ============================================
-- init.lua v3.1 — Para Programadores (FIXED)
-- Estilo Apple minimalista | Sin plugins pesados
-- 0 plugins obligatorios | mini.nvim opcional
-- ============================================

-- ============================================
-- 1. OPCIONES GENERALES
-- ============================================

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.syntax = "on"
vim.opt.showmode = false
vim.opt.ruler = false
vim.opt.laststatus = 2
vim.opt.cmdheight = 1
vim.opt.timeoutlen = 300
vim.opt.updatetime = 300
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.hidden = true
vim.opt.confirm = true
vim.opt.signcolumn = 'yes'
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.cursorline = true

-- ============================================
-- 2. INDENTACION Y TABS
-- ============================================

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.filetype = 'on'
vim.cmd('filetype indent on')

-- ============================================
-- 3. UNDO PERSISTENTE
-- ============================================

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('data') .. '/undo'
if vim.fn.isdirectory(vim.opt.undodir:get()[1]) == 0 then
  vim.fn.mkdir(vim.opt.undodir:get()[1], 'p')
end

-- ============================================
-- 4. APARIENCIA — COLORES APPLE
-- ============================================

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

-- Diagnostics highlights
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
-- 5. BARRA DE ESTADO INTELIGENTE (FIXED)
-- ============================================

-- Colores por modo
local mode_colors = {
  n = '#64D2FF',
  i = '#34C759',
  v = '#FF375F',
  V = '#FF375F',
  ['\22'] = '#FF375F',
  c = '#FF9F0A',
  r = '#FF6B6B',
  t = '#A2845E',
}

local mode_labels = {
  n = 'NORMAL',
  i = 'INSERT',
  v = 'VISUAL',
  V = 'V-LINE',
  ['\22'] = 'V-BLOCK',
  c = 'COMMAND',
  r = 'REPLACE',
  t = 'TERMINAL',
}

-- Obtener rama de git
local function get_git_branch()
  local handle = io.popen('git branch --show-current 2>/dev/null')
  if not handle then return '' end
  local branch = handle:read('*a'):gsub('%s+$', '')
  handle:close()
  return branch
end

-- Contar diagnostics
local function get_diagnostics()
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

-- Funcion de barra de estado (sin string.format con %)
function _G.statusline()
  local mode = vim.fn.mode()
  local mode_color = mode_colors[mode] or '#8E8E93'
  local mode_label = mode_labels[mode] or mode:upper()
  
  local filename = vim.fn.expand('%:t')
  if filename == '' then filename = '[Sin nombre]' end
  local modified = vim.bo.modified and ' [+]' or ''
  local readonly = vim.bo.readonly and ' [RO]' or ''
  
  local filetype = vim.bo.filetype
  if filetype == '' then filetype = 'text' end
  
  local encoding = vim.bo.fileencoding
  if encoding == '' then encoding = vim.o.encoding end
  
  local indent = vim.bo.expandtab and (vim.bo.shiftwidth .. 'sp') or (vim.bo.tabstop .. 't')
  
  local branch = get_git_branch()
  local diagnostics = get_diagnostics()
  
  local line = vim.fn.line('.')
  local col = vim.fn.col('.')
  local total = vim.fn.line('$')
  local percent = math.floor((line / total) * 100)
  
  -- Construir string manualmente (sin string.format para evitar conflictos con %)
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
  
  -- Actualizar color del modo dinamicamente
  vim.cmd('highlight StatusLineMode guibg=' .. mode_color .. ' guifg=#1C1C1E gui=bold')
  
  -- Usar %#Highlight# para aplicar colores en statusline
  return '%#StatusLineMode#' .. left .. '%#StatusLine#' .. '%=' .. center .. '%=' .. right
end

vim.o.statusline = '%!v:lua.statusline()'

-- ============================================
-- 6. NETRW
-- ============================================

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 25
vim.g.netrw_keepdir = 0
vim.g.netrw_localcopydircmd = 'cp -r'

-- ============================================
-- 7. LEADER KEY
-- ============================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================
-- 8. MAPPINGS BASICOS
-- ============================================

vim.keymap.set('n', '<C-s>', ':w<CR>', { silent = true })
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a', { silent = true })
vim.keymap.set('n', '<C-q>', ':q<CR>', { silent = true })
vim.keymap.set('i', '<C-q>', '<Esc>:q<CR>', { silent = true })

vim.keymap.set('v', '<C-c>', '"+y', { silent = true })
vim.keymap.set('n', '<C-c>', '"+yy', { silent = true })
vim.keymap.set('v', '<C-x>', '"+d', { silent = true })
vim.keymap.set('n', '<C-v>', '"+p', { silent = true })
vim.keymap.set('i', '<C-v>', '<Esc>"+pa', { silent = true })
vim.keymap.set('v', '<C-v>', '"+p', { silent = true })

-- ============================================
-- 9. MAPPINGS AVANZADOS
-- ============================================

-- Splits
vim.keymap.set('n', '<C-h>', '<C-w>h', { silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { silent = true })

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { silent = true })
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { silent = true })
vim.keymap.set('n', '<leader>bd', ':bd<CR>', { silent = true })
vim.keymap.set('n', '<leader>bo', ':%bd|e#<CR>', { silent = true })

-- Explorador
vim.keymap.set('n', '<leader>e', ':Lexplore<CR>', { silent = true })
vim.keymap.set('n', '<leader>E', ':Lexplore %:p:h<CR>', { silent = true })

-- Busqueda
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', { silent = true })
vim.keymap.set('n', '<leader>/', '"fyiw/<C-r>f<CR>', { silent = true })
vim.keymap.set('n', '<leader>*', ':%s/<C-r><C-w>//gc<Left><Left><Left>', {})
vim.keymap.set('n', '<leader>nh', ':nohlsearch<CR>', { silent = true })

-- Edicion rapida
vim.keymap.set('n', '<leader>rn', '*Ncgn', { silent = true })
vim.keymap.set('n', '<leader>y', '"+y', { silent = true })
vim.keymap.set('n', '<leader>Y', '"+Y', { silent = true })
vim.keymap.set('n', '<leader>d', '"_d', { silent = true })
vim.keymap.set('n', '<leader>D', '"_D', { silent = true })
vim.keymap.set('v', '<leader>d', '"_d', { silent = true })
vim.keymap.set('n', '<leader>p', '"0p', { silent = true })
vim.keymap.set('v', '<leader>p', '"0p', { silent = true })

-- Mover lineas
vim.keymap.set('n', 'J', ':m .+1<CR>==', { silent = true })
vim.keymap.set('n', 'K', ':m .-2<CR>==', { silent = true })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { silent = true })

-- Indentar en visual
vim.keymap.set('v', '<', '<gv', { silent = true })
vim.keymap.set('v', '>', '>gv', { silent = true })

-- ============================================
-- 10. AUTO-PAIRS NATIVO
-- ============================================

local auto_pairs = {
  ['('] = ')',
  ['['] = ']',
  ['{'] = '}',
  ["'"] = "'",
  ['"'] = '"',
  ['`'] = '`',
}

for open, close in pairs(auto_pairs) do
  vim.keymap.set('i', open, open .. close .. '<Left>', { silent = true })
end

-- Saltar sobre closing bracket
vim.keymap.set('i', '<C-l>', function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local next_char = line:sub(col + 1, col + 1)
  if next_char == ')' or next_char == ']' or next_char == '}' or next_char == '"' or next_char == "'" or next_char == '`' then
    return '<Right>'
  end
  return '<C-l>'
end, { silent = true, expr = true })

-- ============================================
-- 11. FUNCIONES CON TECLAS F
-- ============================================

-- F1: Terminal flotante
vim.keymap.set('n', '<F1>', function()
  vim.cmd('belowright 15split | terminal')
  vim.cmd('startinsert')
end, { silent = true })

-- F2: Toggle numeros relativos
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

-- F5: Ejecutar archivo
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

-- ============================================
-- 12. MINI.NVIM (OPCIONAL)
-- ============================================

local mini_ok = pcall(require, 'mini')

if mini_ok then
  require('mini.pick').setup({ options = { use_cache = true } })
  vim.keymap.set('n', '<leader>f', ':Pick files<CR>', { silent = true })
  vim.keymap.set('n', '<leader>g', ':Pick grep_live<CR>', { silent = true })
  vim.keymap.set('n', '<leader>b', ':Pick buffers<CR>', { silent = true })

  require('mini.surround').setup()
  require('mini.comment').setup()

  require('mini.indentscope').setup({
    symbol = '│',
    draw = { delay = 0, animation = require('mini.indentscope').gen_animation.none() }
  })

  require('mini.diff').setup({
    view = {
      style = 'sign',
      signs = { add = '+', change = '~', delete = '-' }
    }
  })

  require('mini.pairs').setup()
else
  vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
      vim.notify(
        'mini.nvim no instalado (opcional). Ejecuta:' .. '\\n' ..
        'git clone https://github.com/echasnovski/mini.nvim ' ..
        '~/.config/nvim/pack/plugins/start/mini.nvim',
        vim.log.levels.INFO
      )
    end,
    once = true
  })
end

-- ============================================
-- 13. AUTOCOMMANDS
-- ============================================

-- Autoguardado
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost' }, {
  pattern = '*',
  command = 'silent! wall'
})

-- Cursorline dinamico
vim.api.nvim_create_autocmd('InsertEnter', {
  callback = function() vim.opt.cursorline = false end
})
vim.api.nvim_create_autocmd('InsertLeave', {
  callback = function() vim.opt.cursorline = true end
})

-- Highlight al yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
  end
})

-- Ultima posicion
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end
})

-- Auto crear directorios
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    local dir = vim.fn.expand('<afile>:p:h')
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end
})

-- ============================================
-- 14. MENSAJE DE BIENVENIDA
-- ============================================

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    print('init.lua v3.1 — Listo para programar')
    print('F1:Terminal F2:RelNums F3:Wrap F4:Format F5:Run F6:Spell F7:Diff F8:Buffers')
    print('<Space>f:Files <Space>g:Grep <Space>e:Explorer | gcc:Comment | sa\":Surround')
  end,
  once = true
})

-- ============================================
-- Fin del init.lua v3.1
-- ============================================
