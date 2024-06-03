local vscode = require 'vscode'
-- vim.opt.clipboard = 'unnamedplus'

local function toggle_line_number()
  local lineNumberConfig = vscode.get_config(
    'editor.lineNumbers')
  if lineNumberConfig == 'relative' then
    vscode.update_config('editor.lineNumbers', 'on', 'global')
  elseif lineNumberConfig == 'on' then
    vscode.update_config('editor.lineNumbers', 'relative', 'global')
  end
end

local function toggle_zen_mode()
  vscode.action('workbench.action.toggleZenMode')
  vscode.action('workbench.action.toggleMaximizeEditorGroup')
end

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
-- Remaps
vim.g.mapleader = ' '

-- vim.keymap.set('n', '<leader>pv', [[lua vscode.action 'workbench.action.files.saveFiles']])
--
-- vim.keymap.set('n', '<leader>pv', function()
--   vscode.action 'workbench.action.toggleSidebarVisibility'
-- end, { noremap = true })

-- vim.keymap.set('n', 'H', '^')
-- vim.keymap.set('x', 'H', '^')
-- vim.keymap.set('n', 'L', 'g_')
-- vim.keymap.set('x', 'L', 'g_')
vim.keymap.set('n', 'J', 'mzJ`z', { noremap = true })

vim.keymap.set({ 'n', 'v' }, '<leader>y', '\"+y', { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '\"+p', { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<leader>P', '\"+P', { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<leader>d', '\"+d', { noremap = true })
-- vim.keymap.set({ 'n' }, '<leader>sf', function()
--   vscode.action 'workbench.action.quickOpen'
-- end)

vim.keymap.set('n', '<leader>vl', toggle_line_number, { noremap = true })
vim.keymap.set('n', '<leader>vz', toggle_zen_mode, { noremap = true })
vim.keymap.set('n', '<leader>vw', function() vscode.action('workbench.action.switchWindow') end, { noremap = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = 'HiFlapYank' })
  end,
})
vim.keymap.set('n', 'gr', function()
  vscode.action 'editor.action.goToReferences'
end, { noremap = true })
vim.cmd [[
    command! -nargs=0 Minimap lua require('vscode').action('editor.action.toggleMinimap')
]]


-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      require('mini.move').setup {
        left = '',
        right = '',
        down = '<M-j>',
        up = '<M-k>',

        -- Move current line in Normal mode
        line_left = '',
        line_right = '',
        line_down = '<M-j>',
        line_up = '<M-k>',
      }
      require('mini.jump').setup { silent = true }
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
    end
  },
  {
    'chrisgrieser/nvim-spider',
    lazy = true,
    config = function()
      require('spider').setup {
        skipInsignificantPunctuation = true,
        subwordMovement = false
      }
      vim.keymap.set(
        { "n", "o", "x" },
        "w",
        "<cmd>lua require('spider').motion('w')<CR>",
        { desc = "Spider-w" }
      )
      vim.keymap.set(
        { "n", "o", "x" },
        "e",
        "<cmd>lua require('spider').motion('e')<CR>",
        { desc = "Spider-e" }
      )
      vim.keymap.set(
        { "n", "o", "x" },
        "b",
        "<cmd>lua require('spider').motion('b')<CR>",
        { desc = "Spider-b" }
      )
    end
  },
  {
    'bkad/CamelCaseMotion',
    init = function()
      vim.g.camelcasemotion_key = '<leader>'
    end
  }
})