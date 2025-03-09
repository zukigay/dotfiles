-- define common options
local opts = {
    noremap = true,      -- non-recursive
    silent = true,       -- do not show message
}

-----------------
-- Normal mode --
-----------------

vim.g.mapleader = " "

-- Better window navigation
--vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
--vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
--vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
--vim.keymap.set('n', '<C-l>', '<C-w>l', opts)


-- vim.keymap.set('n', '<C-a>', ':Lexplore<CR>', opts)


-- Resize with arrows
-- delta: 2 lines
-- vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', opts)
-- vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', opts)
-- vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts)
-- vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-----------------
-- Visual mode --
-----------------

-- Hint: start visual mode with the same area as the previous area and the same mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- source https://youtu.be/KfENDDEpCsI?si=nLggFVp-upIw9s5h&t=214
vim.keymap.set('n', "<C-d>", "<C-d>zz", opts)
vim.keymap.set('n', "<C-u>", "<C-u>zz", opts)
vim.keymap.set('v', "<C-d>", "<C-d>zz", opts)
vim.keymap.set('v', "<C-u>", "<C-u>zz", opts)

vim.keymap.set('n', "n", "nzz", opts)
vim.keymap.set('v', "n", "nzz", opts)
vim.keymap.set('n', "<S-n>", "<S-n>zz", opts)
vim.keymap.set('v', "<S-n>", "<S-n>zz", opts)
vim.keymap.set('n', '<Up', "<Nop>", opts)
vim.keymap.set('n', '<Down>', "<Nop>", opts)
vim.keymap.set('n', '<Left>', "<Nop>", opts)
vim.keymap.set('n', '<Right>', "<Nop>", opts)


--vim.keymap.set('n', "<leader>r", ':shell ')


--vim.keymap.set('n','<leader>r', function()  end)


-- tab support
--vim.keymap.set('n','<C-h>', ':tabNext<CR>', opts)
--vim.keymap.set('n','<C-l>', ':tabnext<CR>', opts)
-- vim.keymap.set('n','<C-j>', ':tabclose<CR>', opts)
-- vim.keymap.set('n','<C-k>', ':tabnew<CR>', opts)

-- vim.keymap.set('n','<leader>j', ':tabNext<CR>', opts)
-- vim.keymap.set('n','<leader>k', ':tabnext<CR>', opts)
vim.keymap.set('n','<C-j>', ':tabNext<CR>', opts)
vim.keymap.set('n','<C-k>', ':tabnext<CR>', opts)
vim.keymap.set('n','<leader>j', ':tabclose<CR>', opts)
vim.keymap.set('n','<leader>k', ':tabnew<CR>', opts)
