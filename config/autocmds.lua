-- ============================================
-- Autocomandos
-- ============================================

local autocmd = vim.api.nvim_create_autocmd

-- Autoguardado al perder foco
autocmd({ 'BufLeave', 'FocusLost' }, {
  pattern = '*',
  command = 'silent! wall'
})

-- Cursorline dinámico
autocmd('InsertEnter', {
  callback = function() vim.opt.cursorline = false end
})
autocmd('InsertLeave', {
  callback = function() vim.opt.cursorline = true end
})

-- Highlight al yank
autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
  end
})

-- Regresar a última posición
autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end
})

-- Auto-crear directorios al guardar
autocmd('BufWritePre', {
  callback = function()
    local dir = vim.fn.expand('<afile>:p:h')
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end
})
