-- ============================================
-- Keymaps — Todos los atajos de teclado
-- ============================================

local map = vim.keymap.set

-- ============================================
-- Básicos (guardar, salir, clipboard)
-- ============================================

map('n', '<C-s>', ':w<CR>', { silent = true })
map('i', '<C-s>', '<Esc>:w<CR>a', { silent = true })
map('n', '<C-q>', ':q<CR>', { silent = true })
map('i', '<C-q>', '<Esc>:q<CR>', { silent = true })

map('v', '<C-c>', '"+y', { silent = true })
map('n', '<C-c>', '"+yy', { silent = true })
map('v', '<C-x>', '"+d', { silent = true })
map('n', '<C-v>', '"+p', { silent = true })
map('i', '<C-v>', '<Esc>"+pa', { silent = true })
map('v', '<C-v>', '"+p', { silent = true })

-- ============================================
-- Navegación entre splits
-- ============================================

map('n', '<C-h>', '<C-w>h', { silent = true })
map('n', '<C-j>', '<C-w>j', { silent = true })
map('n', '<C-k>', '<C-w>k', { silent = true })
map('n', '<C-l>', '<C-w>l', { silent = true })

-- ============================================
-- Navegación entre buffers
-- ============================================

map('n', '<Tab>', ':bnext<CR>', { silent = true })
map('n', '<S-Tab>', ':bprevious<CR>', { silent = true })
map('n', '<leader>bd', ':bd<CR>', { silent = true })
map('n', '<leader>bo', ':%bd|e#<CR>', { silent = true })

-- ============================================
-- Explorador
-- ============================================

map('n', '<leader>e', ':Lexplore<CR>', { silent = true })
map('n', '<leader>E', ':Lexplore %:p:h<CR>', { silent = true })

-- ============================================
-- Búsqueda
-- ============================================

map('n', '<Esc>', ':nohlsearch<CR>', { silent = true })
map('n', '<leader>/', '"fyiw/<C-r>f<CR>', { silent = true })
map('n', '<leader>*', ':%s/<C-r><C-w>//gc<Left><Left><Left>', {})
map('n', '<leader>nh', ':nohlsearch<CR>', { silent = true })

-- ============================================
-- Edición rápida
-- ============================================

map('n', '<leader>rn', '*Ncgn', { silent = true })
map('n', '<leader>y', '"+y', { silent = true })
map('n', '<leader>Y', '"+Y', { silent = true })
map('n', '<leader>d', '"_d', { silent = true })
map('n', '<leader>D', '"_D', { silent = true })
map('v', '<leader>d', '"_d', { silent = true })
map('n', '<leader>p', '"0p', { silent = true })
map('v', '<leader>p', '"0p', { silent = true })

-- ============================================
-- Mover líneas
-- ============================================

map('n', 'J', ':m .+1<CR>==', { silent = true })
map('n', 'K', ':m .-2<CR>==', { silent = true })
map('v', 'J', ":m '>+1<CR>gv=gv", { silent = true })
map('v', 'K', ":m '<-2<CR>gv=gv", { silent = true })

-- ============================================
-- Indentar en visual mode
-- ============================================

map('v', '<', '<gv', { silent = true })
map('v', '>', '>gv', { silent = true })
