-- ============================================
-- Opciones generales
-- ============================================

local opt = vim.opt
local g = vim.g

-- Generales
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.termguicolors = true
opt.background = "dark"
opt.syntax = "on"
opt.showmode = false
opt.ruler = false
opt.laststatus = 2
opt.cmdheight = 1
opt.timeoutlen = 300
opt.updatetime = 300
opt.hlsearch = true
opt.incsearch = true
opt.wrap = false
opt.swapfile = false
opt.clipboard = 'unnamedplus'
opt.hidden = true
opt.confirm = true
opt.signcolumn = 'yes'
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.cursorline = true

-- Indentación
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.cindent = true
opt.filetype = 'on'

-- Filetype indent
vim.cmd('filetype indent on')

-- Undo persistente
opt.undofile = true
opt.undodir = vim.fn.stdpath('data') .. '/undo'
if vim.fn.isdirectory(opt.undodir:get()[1]) == 0 then
  vim.fn.mkdir(opt.undodir:get()[1], 'p')
end

-- Leader keys
g.mapleader = " "
g.maplocalleader = " "
