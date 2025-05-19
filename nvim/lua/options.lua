
-- https://martinlwx.github.io/en/config-neovim-from-scratch/
-- Hint: use `:h <option>` to figure out the meaning if needed
vim.opt.clipboard = 'unnamedplus'   -- use system clipboard 
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
vim.opt.mouse = 'a'                 -- allow the mouse to be used in Nvim

-- Tab
vim.opt.tabstop = 4                 -- number of visual spaces per TAB
vim.opt.softtabstop = 4             -- number of spacesin tab when editing
vim.opt.shiftwidth = 4              -- insert 4 spaces on a tab
vim.opt.expandtab = true            -- tabs are spaces, mainly because of python

-- UI config
vim.opt.number = true               -- show absolute number
vim.opt.relativenumber = true       -- add numbers to each line on the left side
vim.opt.cursorline = true           -- highlight cursor line underneath the cursor horizontally
vim.opt.splitbelow = true           -- open new vertical split bottom
vim.opt.splitright = true           -- open new horizontal splits right
-- vim.opt.termguicolors = true        -- enabl 24-bit RGB color in the TUI
vim.opt.showmode = false            -- we are experienced, wo don't need the "-- INSERT --" mode hint

-- vim-netrw
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0

-- extra vim-netrw options to make it a full nerd tree like setup
-- credit it to https://shapeshed.com/vim-netrw/
--vim.g.netrw_browse_split = 4
-- vim.g.netrw_altv = 1
--vim.g.netrw_winsize = 25
vim.cmd("noremap <Up> <Nop>")
vim.cmd("noremap <Down> <Nop>")
vim.cmd("noremap <Left> <Nop>")
vim.cmd("noremap <Right> <Nop>")
vim.cmd('autocmd VimLeave * set guicursor= | call chansend(v:stderr, "\x1b[ q")')

-- add syntax highlighting to pico8 games
vim.cmd("au BufRead,BufNewFile *.p8 set filetype=lua")

-- Searching
vim.opt.incsearch = true            -- search as characters are entered
vim.opt.hlsearch = false            -- do not highlight matches
vim.opt.ignorecase = true           -- ignore case in searches by default
vim.opt.smartcase = true            -- but make it case sensitive if an uppercase is entered
