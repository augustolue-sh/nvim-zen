-- ============================================
-- init.lua — Punto de entrada
-- nvim-zen v3.2 Modular
-- ============================================

-- Cargar configuración base
require('config.options')
require('config.appearance')
require('config.netrw')
require('config.autocmds')

-- Cargar funciones y keymaps
require('core.functions')
require('core.keymaps')

-- Cargar plugins opcionales
require('plugins.mini')
